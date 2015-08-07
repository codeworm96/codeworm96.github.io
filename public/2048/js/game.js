//2048 game main

var width = 120;
var height = 120;
var r = 10;
var color = d3.scale.ordinal()
  .range(["#98abc5", "#eee4da", "#ede0c8", "#f2b179", "#f59563", "#f67c5f", "#f65e3b",
    "#edcf72", "#edcc61", "#edc850", "#edc53f", "#edc22e"]);
var board = new Array(4);
var i;
for (i = 0; i < 4; ++i){
  board[i] = new Array(4);
}
for (i = 0; i < 4; ++i){
  for (var j = 0; j < 4; ++j){
    board[i][j] = 0;
  }
}

function render() {
  var data = [];
  for (var i = 0; i < 4; ++i){
    for (var j = 0; j < 4; ++j){
      data.push({
        x: i,
        y: j,
        value: board[i][j]
      });
    }
  }

  var cells = d3.selectAll('.cell')
    .data(data)
    .attr('transform', function(d) { return 'translate(' + d.x * width + ',' + d.y * height +')'; });
  cells.select('rect')
    .style('fill', function(d) { return color(d.value); });
  cells.select('text')
    .text(function(d) {
      if (d.value > 0){
        return d.value;
      }else{
        return '';
      }
    });
}

function init() {
  var data = [];
  for (var i = 0; i < 4; ++i){
    for (var j = 0; j < 4; ++j){
      data.push({
        x: i,
        y: j,
        value: board[i][j]
      });
    }
  }

  var svg = d3.select('.game-container')
    .attr('width', width * 4)
    .attr('height', height * 4);

  var cells = svg.selectAll('.cell')
    .data(data)
    .enter()
    .append('g')
    .attr('width', width)
    .attr('height', height)
    .attr('class', 'cell')
    .attr('transform', function(d) { return 'translate(' + d.x * width + ',' + d.y * height +')'; });

  cells.append('rect')
    .attr('width', width)
    .attr('height', height)
    .attr('rx', r)
    .attr('ry', r)
    .style('fill', function(d) { return color(d.value); });

  cells.append('text')
  .attr('transform', function(d) { return 'translate(' + width / 2 + ',' + height / 2 + ')'; })
    .style('text-anchor', 'middle')
          .attr('dy','0.35em')
    .text(function(d) {
      if (d.value > 0){
        return d.value;
      }else{
        return '';
      }
    });
}

//generate new item
function rand_item() {
  var data = [];
  for (var i = 0; i < 4; ++i){
    for (var j = 0; j < 4; ++j){
      if (board[i][j] === 0){
        data.push({
          x: i,
          y: j
        });
      }
    }
  }
  if (data.length > 0){
    var pos = data[Math.floor(Math.random() * data.length)];
    if (Math.random() > 0.9){
      board[pos.x][pos.y] = 4;
    }else{
      board[pos.x][pos.y] = 2;
    }
  }
}

//move tiles
function move(orient) {
  var i;
  var j;
  var k;
  var merged;
  switch(orient) {
    case 'left':
      for (j = 0; j < 4; ++j){
        merged = false;
        for (i = 0; i < 4; ++i){
        if (board[i][j] > 0){
            k = i;
            while(k > 0){
              if(board[k - 1][j] === 0){
                board[k - 1][j] = board[k][j];
                board[k][j] = 0;
              }else if (!merged && board[k - 1][j] === board[k][j]){
                merged = true;
                board[k - 1][j] += board[k][j];
                board[k][j] = 0;
              }else{
                break;
              }
              --k;
            }
          }
        }
      }
      break;
    case 'up':
      for (i = 0; i < 4; ++i){
        merged = false;
        for (j = 0; j < 4; ++j){
          if (board[i][j] > 0){
            k = j;
            while(k > 0){
              if(board[i][k - 1] === 0){
                board[i][k - 1] = board[i][k];
                board[i][k] = 0;
              }else if (!merged && board[i][k - 1] === board[i][k]){
                merged = true;
                board[i][k - 1] += board[i][k];
                board[i][k] = 0;
              }else{
                break;
              }
              --k;
            }
          }
        }
      }
      break;
    case 'right':
      for (j = 0; j < 4; ++j){
        merged = false;
        for (i = 3; i >= 0; --i){
          if (board[i][j] > 0){
            k = i;
            while(k < 3){
              if(board[k + 1][j] === 0){
                board[k + 1][j] = board[k][j];
                board[k][j] = 0;
              }else if (!merged && board[k + 1][j] === board[k][j]){
                merged = true;
                board[k + 1][j] += board[k][j];
                board[k][j] = 0;
              }else{
                break;
              }
              ++k;
            }
          }
        }
      }
      break;
    case 'down':
      for (i = 0; i < 4; ++i){
        merged = false;
        for (j = 3; j >= 0; --j){
          if (board[i][j] > 0){
            k = j;
            while(k < 3){
              if(board[i][k + 1] === 0){
                board[i][k + 1] = board[i][k];
                board[i][k] = 0;
              }else if (!merged && board[i][k + 1] === board[i][k]){
                merged = true;
                board[i][k + 1] += board[i][k];
                board[i][k] = 0;
              }else{
                break;
              }
              ++k;
            }
          }
        }
      }
      break;
  }
}

function step(orient) {
  move(orient);
  rand_item();
  render();
}
