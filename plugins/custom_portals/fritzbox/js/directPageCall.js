var dc;dc=dc||(function(){"use strict";var lib;lib={};lib.call=function(page){var a=document.createElement("a"),clickEvt=null;a.href=page||"/";document.body.appendChild(a);if(a.click){a.click();}else if(document.dispatchEvent){clickEvt=document.createEvent("MouseEvent");clickEvt.initEvent("click",true,true);a.dispatchEvent(clickEvt);}else if(document.fireEvent){a.fireEvent('onclick');}
document.body.removeChild(a);};return lib;}());