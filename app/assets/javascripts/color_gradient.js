var RED = {
  r:	255,
  g: 0,
  b: 0
};

var GREEN = {
  r:	0,
  g: 255,
  b: 0,
};


function makeGradientColor(percent, opacity, color1, color2) {
    color1 = typeof color1 !== 'undefined' ? color1 : RED;
    color2 = typeof color2 !== 'undefined' ? color2 : GREEN;
    opacity = typeof opacity !== 'undefined' ? opacity : 1;

    function makeChannel(a, b) {
        return(a + Math.round((b-a)*(percent))).toString();
    }

    var colorString = "rgba(";
    colorString += makeChannel(color1.r, color2.r) + ", ";
    colorString += makeChannel(color1.g, color2.g) + ", ";
    colorString += makeChannel(color1.b, color2.b) + ", ";
    colorString += opacity.toString();
    colorString += ")";
    return(colorString);
}

function diffToPercent(base, bench){
  return ((bench - base)/(2.0*(bench + base))) + 0.5;
}
