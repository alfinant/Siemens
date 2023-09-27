function mOvr(src,color)  {
  if(!src.contains(event.fromElement)) {
    src.style.cursor = 'hand'; src.bgColor = color;
   }
}

function mOut(src,color)  {
  if(!src.contains(event.toElement)){
    src.style.cursor = 'default';
    src.bgColor = color;
   }
}

function mClk(src)  {
  if(event.srcElement.tagName=='TD'){
    src.children.tags('A')[0].click();
   }
}
