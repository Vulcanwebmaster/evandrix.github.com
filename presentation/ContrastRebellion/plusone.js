window.___jsl=window.___jsl||{};
window.___jsl.h=window.___jsl.h||'r;gc\/22595239-f24a003b';
window.__GOOGLEAPIS=window.__GOOGLEAPIS||{};
window.__GOOGLEAPIS.gwidget=window.__GOOGLEAPIS.gwidget||{};
window.__GOOGLEAPIS.gwidget.superbatch=false;window.__GOOGLEAPIS.iframes=window.__GOOGLEAPIS.iframes||{};
window.__GOOGLEAPIS.iframes.plusone=window.__GOOGLEAPIS.iframes.plusone_m=window.__GOOGLEAPIS.iframes.plusone||{url:':socialhost:/u/:session_index:/_/+1/fastbutton',params:{count:'',size:'',url:''}};window.___gpq=[];
window.gapi=window.gapi||{};
window.gapi.plusone=window.gapi.plusone||(function(){
  function f(n){return function(){window.___gpq.push(n,arguments)}}
  return{go:f('go'),render:f('render')}})();
function __bsld(){var p=window.gapi.plusone=window.googleapisv0.plusone;var f;while(f=window.___gpq.shift()){
  p[f]&&p[f].apply(p,window.___gpq.shift())}
if (gadgets.config.get("gwidget")["parsetags"]!=="explicit"){gapi.plusone.go();}}
window['___jsl'] = window['___jsl'] || {};window['___jsl']['u'] = 'https:\/\/apis.google.com\/js\/plusone.js';window['___jsl']['f'] = ['googleapis.client','plusone'];window['___lcfg'] = {"gwidget":{"parsetags":"onload","superbatch":false},"iframes":{"sharebox":{"params":{"json":"&"},"url":":socialhost:/u/:session_index:/_/sharebox/dialog"},":socialhost:":"https://apis.google.com","profilecard":{"params":{"style":"#","m":"&"},"url":":socialhost:/u/:session_index:/_/hovercard/appcard"},"plusone_m":{"url":":socialhost:/u/:session_index:/_/+1/fastbutton","params":{"count":"","size":"","url":""}},"plusone":{"url":":socialhost:/u/:session_index:/_/+1/fastbutton","params":{"count":"","size":"","url":""}}},"googleapis.config":{"requestCache":{"enabled":true},"methods":{"chili.people.list":true,"pos.plusones.list":true,"chili.entities.starred.insert":{"cache":{"invalidates":["chili.entities.starred","chili.entitiesDefaultAcl"]}},"chili.people.get":true,"chili.entities.get":true,"pos.plusones.delete":true,"chili.entities.starred.delete":true,"chili.entities.list":true,"pos.plusones.get":true,"chili.groups.list":true,"pos.plusones.getDefaultAcl":{"cache":{"enabled":true}},"chili.entities.starred.get":true,"pos.plusones.insert":true,"chili.activities.list":true,"chili.entitiesDefaultAcl.get":true,"chili.entities.starred.list":true,"chili.activities.get":true,"chili.activities.search":true,"pos.plusones.getSignupState":true},"versions":{"chili":"v1","pos":"v1"},"rpc":"/rpc","transport":{"isProxyShared":true},"sessionCache":{"enabled":true},"proxy":"https://clients6.google.com/static/proxy.html","developerKey":"AIzaSyCKSbrvQasunBoV16zDH9R33D88CeLr9gQ","jsh":"r;gc/22595239-f24a003b","auth":{"useInterimAuth":false}}};var jsloader=window.jsloader||{};
var gapi=window.gapi||{};
(function(){function h(){return window.___jsl=window.___jsl||{}}function m(c,d,b){b=n(b).join(c);i.length>0&&(b+=d+i.join(c));return b}function n(c){c.sort();for(var d=0,b,a;b=c[d];)b==a?c.splice(d,1):(a=b,++d);return c}function s(c){if((o||document.readyState)!="loading")return!1;if(typeof window.___gapisync!="undefined")return window.___gapisync;if(c&&(c=c.sync,typeof c!="undefined"))return c;for(var c=!1,d=document.getElementsByTagName("meta"),b=0,a;a=!c&&d[b];++b)"generator"==a.getAttribute("name")&&
"blogger"==a.getAttribute("content")&&(c=!0);return c}function p(c,d){f="";i=[];j=window.console||window.opera&&window.opera.postError;g=c;o=d;var b,a=g.match(t)||g.match(u);try{b=a?decodeURIComponent(a[2]):h().h}catch(e){}b&&(b=b.split(";"),f=b.shift(),l=(a=f!=="r")?b.shift():"https://ssl.gstatic.com/webclient/js",k=b.shift(),q=(a=f==="d")&&b.shift()||"gcjs-3p",r=a&&b.shift()||"")}var t=/\?([^&#]*&)*jsh=([^&#]*)/,u=/#([^&]*&)*jsh=([^&]*)/,v=/^https:\/\/ssl.gstatic.com\/webclient\/js(\/[a-zA-Z0-9_\-]+)*\/[a-zA-Z0-9_\-\.:!]+\.js$/,
w=/^(https?:)?\/\/([^/:@]*)(:[0-9]+)?\//,f,l,q,r,k,i,j,g,o;p(document.location.href);jsloader.load=function(c,d,b){var a;if(!c||c.length==0)j&&j.warn("Cannot load empty features.");else if(f==="d")a=l+"/"+m(":","!",c),a+=".js?container="+q+"&c=2&jsload=0",k&&(a+="&r="+k),r=="d"&&(a+="&debug=1");else if(f==="r"||f==="f")a=l+"/"+k+"/"+m("__","--",c)+".js";else{var e="Cannot respond for features ["+c.join(",")+"].";j&&j.warn(e)}e=d;d=b;if(a){if(b=e){if(h().c)throw"Cannot continue until a pending callback completes.";
h().c=b;h().o=1}a=b=a;if(f==="r")a=a.match(v);else if(e=a.match(w),(a=h().m)&&e){var e=e[2],g=e.lastIndexOf(a);a=(g==0||a.charAt(0)=="."||e.charAt(g-1)==".")&&e.length-a.length==g}else a=!1;if(!a)throw"Cannot load url "+b+".";s(d)?document.write('<script src="'+b+'"><\/script>'):(d=document.createElement("script"),d.setAttribute("src",b),document.getElementsByTagName("head")[0].appendChild(d));i=n(i.concat(c))}else e&&e()};jsloader.reinitialize_=function(c,d){p(c,d)}})();
gapi.load=function(a,b){jsloader.load(a.split(":"),b)};
gapi.load('googleapis.client:plusone', window['__bsld'], null);