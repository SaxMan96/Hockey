function getRandomAngle(previousValue) {
    return 135;
    if(Math.random()>= 0.5)
        return Math.floor(previousValue + Math.random() * 360) % 90 - 45;
    else
        return Math.floor(previousValue + Math.random() * 360) % 90 + 135;
}
function getRandomMagnitude(min,max,randSeed) {

    return Math.floor((Math.random()*randSeed)%1*(max-min)+min);
}
