function NMoveAvg(context, N) {
  this._context = context;
  this._points = {
    x: [],
    y: []
  };
  this._N = N;
}

NMoveAvg.prototype = {
  areaStart: function() {
    this._line = 0;
  },
  areaEnd: function() {
    this._line = NaN;
  },
  lineStart: function() {
    this._point = 0;
  },
  lineEnd: function() {
    if (this._line || (this._line !== 0 && this._point === 1)) this._context.closePath();
    this._line = 1 - this._line;
  },
  point: function(x, y) {
    x = +x, y = +y;

    this._points.x.push(x);
    this._points.y.push(y);

    if (this._points.x.length < this._N) return;

    var aX = this._points.x.reduce(function(a, b) {
        return a + b;
      }, 0) / this._N,
      aY = this._points.y.reduce(function(a, b) {
        return a + b;
      }, 0) / this._N;

    this._points.x.shift();
    this._points.y.shift();

    switch (this._point) {
      case 0:
        this._point = 1;
        this._line ? this._context.lineTo(aX, aY) : this._context.moveTo(aX, aY);
        break;
      case 1:
        this._point = 2; // proceed
      default:
        this._context.lineTo(aX, aY);
        break;
    }
  }
};

export default (function custom(N) {

  function nMoveAge(context) {
    return new NMoveAvg(context, N);
  }

  nMoveAge.N = function(N) {
    return custom(+N);
  };

  return nMoveAge;
})(0);
