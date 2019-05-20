--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>), mappend, mconcat)
import           Control.Monad (liftM)
import           Hakyll
import           Text.Pandoc.Options

import           Text.Blaze.Html                 (toHtml, toValue, (!))
import qualified Text.Blaze.Html5                as H
import qualified Text.Blaze.Html5.Attributes     as A

--------------------------------------------------------------------------------

pandocMathCompiler = let
    writerOptions = defaultHakyllWriterOptions { writerHTMLMathMethod = MathJax "" }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions
    
siteName = "codeworm96's blog"

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "img/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "misc/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- About page
    match "about.md" $ do
        let ctx = constField "title" "About"  <>
                      constField "about" "about" <> -- For nav
                      defaultContext
        route   $ constRoute "index.html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/about.html" ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    -- Posts
    match "posts/*" $ do
        let ctx = constField "blog" "blog" <> -- For nav
                      postCtxWithTags tags
        route $ setExtension "html"
        compile $ pandocMathCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html" ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

    -- Tags pages
    tagsRules tags $ \tag pattern -> do
        let title = "Tag::" ++ tag
        -- Copied from posts, need to refactor
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let ctx = constField "title" title <>
                          constField "tag" "tag" <> -- For nav
                          listField "posts" (postCtxWithTags tags) (return posts) <>
                          defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    -- Tag cloud page
    create ["tagcloud.html"] $ do
        route idRoute
        compile $ do
            let tagList = map (\(t, _) -> Item (tagsMakeId tags t) t) (tagsMap tags)
                tagCloudCtx = listField "tagcloud" defaultContext (return tagList) <>
                                  constField "title" "All Tags" <>
                                  constField "tag" "tag" <> -- For nav
                                  defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/tagcloud.html" tagCloudCtx
                >>= loadAndApplyTemplate "templates/default.html" tagCloudCtx
                >>= relativizeUrls

    -- Archive page
    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) <>
                    constField "title" "Archives" <>
                    constField "archive" "archive" <> -- For nav
                    defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    -- paginate
    pages <- buildPaginateWith grouper "posts/*" makeId

    paginateRules pages $ \pageNum pattern -> do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAllSnapshots pattern "content"
            let paginateCtx = paginateContext pages pageNum
                ctx = constField "title" "codeworm96's blog" <>
                          constField "blog" "blog" <> -- For nav
                          listField "posts" (postCtxWithTags tags) (return posts) <>
                          paginateCtx <>
                          defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/page.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------

-- For pagination
grouper :: MonadMetadata m => [Identifier] -> m [[Identifier]]
grouper ids = (liftM (paginateEvery 6) . sortRecentFirst) ids

makeId :: PageNumber -> Identifier
makeId pageNum = fromFilePath $ if pageNum == 1
                     then "blog/index.html"
                     else "blog/page" ++ (show pageNum) ++ "/index.html"

-- For tag rendering
simpleRenderLink :: String -> (Maybe FilePath) -> Maybe H.Html
simpleRenderLink _   Nothing         = Nothing
simpleRenderLink tag (Just filePath) =
  Just $ H.a ! A.href (toValue $ toUrl filePath) $ toHtml tag

postTagsField :: String -> Tags -> Context a
postTagsField = tagsFieldWith getTags simpleRenderLink mconcat

postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" <>
    teaserField "teaser" "content" <>
    defaultContext

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags =
    postTagsField "tags" tags <>
    postCtx
