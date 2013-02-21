<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>

<html>
<head>

<title>Insert title here</title>
<style>
.contextmenu{
  visibility:hidden;
  background:#ffffff;
  border:1px solid #ccc;
  z-index: 10;
  position: relative;
  width: 140px;
  padding:8px;
}
.contextmenu div{
	padding-left: 5px;
	font-size:14px;
	padding-bottom:6px;
}
.contextmenu div a{
	color:#333;
	text-decoration:none;
}
.contextmenu div a:visited{
	color:#333;
	text-decoration:none;
}
.markerLabel{
	color:#fff;
	font-size:14px;
	width:17px;
	text-align:center;
	
}
.evaluateWindow{
height:100px;
overflow-y:hidden;
overflow-x:hidden;
}
.evaluateWindow p{
margin:0px;margin-bottom:5px;
color:#333;
font-size:14px;
}
.buttomPanel{
width:1270px;
height:47px;
background-color:#f4f3ef;
padding-top:10px;
padding-left:10px;
box-shadow: 0px -5px 5px #777;
position:absolute; 
top:562px;left:0;
}
.buttomPanel span a{
color:#555;

text-decoration:none;
}
.buttomPanel span a:visited{
color:#555;

text-decoration:none;
}
.buttomPanel span{
color:#555;
font-size:16px;
padding-left:10px;
padding-right:10px;
border-right:solid 1px #333;

}
.reset{
color:#777;
font-size:13px;
text-decoration:none;
}

#sliderDiv{
top:52px;
height:510px;
width:950px;
position:absolute;
background-color:#f4f3ef;
box-shadow: 5px 0px 5px #666;

left:-960px;
}
#searchAress{
-webkit-border-radius: 5px;
border-radius: 5px;
border:solid 1px #ccc;
width:200px;
height: 20px;
background-image:url('img/search.png');
background-repeat:no-repeat;
background-size: 18px 18px;
background-position:3px 3px;
padding-left:24px;
color:#999;
}
.queryDiv{
-webkit-border-radius: 5px;
border-radius: 5px;
width:200px;
padding-top:5px;
padding-bottom:3px;
background-color:#fff;
border:solid 1px #ccc;
background-image:url('img/search.png');
background-repeat:no-repeat;
background-size: 18px 18px;
background-position:3px 3px;
padding-left:24px;
color:#999;
font-size:13px;
}
.queryDiv input{
border:0;
color:#999;


}
</style>
<link href="css/jqvmap.css" media="screen" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/json.js"></script>
<link href="js/jquery-ui/css/ui-darkness/jquery-ui-1.10.0.custom.css" rel="stylesheet"/>
<script src="js/jquery-ui/js/jquery-ui-1.10.0.custom.js"></script>
<script src="js/chart/highcharts.js"></script>
<script type="text/javascript" src="js/jquery.raty.min.js"></script>
<script src="js/chart/modules/exporting.js"></script>
<script type="text/javascript" src="http://oauth.googlecode.com/svn/code/javascript/oauth.js"></script>
<script type="text/javascript" src="http://oauth.googlecode.com/svn/code/javascript/sha1.js"></script>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD1WS5oZil_6A-DiEbHeyPnGI5IC-3_Eto&sensor=false">
    </script>
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?libraries=places&sensor=false"></script>
<script src="js/markerWithLabel.js"></script>

<script type="text/javascript">
   // var url='http://www.zillow.com/webservice/GetRegionChildren.htm';
   var generalCategory='<%=request.getAttribute("gtype")%>';
   var subCategory='<%=request.getAttribute("stype")%>';
   
   var mapstyle=[
                 {
                	    "featureType": "water",
                	    "elementType": "geometry",
                	    "stylers": [
                	      { "hue": "#00d4ff" }
                	    ]
                	  },{
                	    "featureType": "landscape.man_made",
                	    "stylers": [
                	      { "hue": "#00ffd5" }
                	    ]
                	  },{
                	    "featureType": "poi",
                	    "stylers": [
                	      { "hue": "#00ffa2" }
                	    ]
                	  },{
                	    "featureType": "road.highway",
                	    "stylers": [
                	      { "hue": "#0091ff" }
                	    ]
                	  },{
                	    "featureType": "road.arterial",
                	    "stylers": [
                	      { "saturation": -100 },
                	      { "lightness": 18 }
                	    ]
                	  },{
                	  }
                	];
    $(function() {
    	//$.post("/WebService/ajax",{url:convert(url)},function(data){}); 
    	$.fn.raty.defaults.path = 'js/img';
    	
    	
    	$('#searchAress').on('keyup', function(e) {
    	    if (e.which == 13) {
    	    	codeAddress($('#searchAress').val());
    	    }
    	});
    	$('#keywordsInput').on('keyup', function(e) {
    	    if (e.which == 13) {
    	    	search();
    	    }
    	});
    	
    	$('#radiusInput').on('keyup', function(e) {
    	    if (e.which == 13) {
    	    	search();
    	    }
    	});
    	
    	
    	initialize();
    	
    	
    	
    });
    //finish onload
 		function report(url,address){
 			clearRegion(myOverlay);
 			codeAddress(address);
 			var nurl="http://api.census.gov/data/2010/sf1?key=219b7e472bceaa9e85d81214fc0f18d54e6f8def&get=H011A0002,H011A0003,H011A0004,H011B0002,H011B0003,H011B0004,H011C0002,H011C0003,H011C0004,H011D0002,H011D0003,H011D0004,H011E0002,H011E0003,H011E0004,H011F0002,H011F0003,H011F0004"+url;
 			$.post("/WebService/ajax",{url:nurl},function(data){
 			var mortage=[];
 			var clean=[];
 			var rent=[];
			var nums;
 			for(var i=1;i<=18;i++){
 				nums=parseInt(data[1][i-1]);
 				if((i)%3==1){
 					mortage.push(nums);
 				}
 				if((i)%6==2){
 					clean.push(nums);
 				}
 				if((i)%6==0){
 					rent.push(nums);
 				}
 			}
 			$("#container").html("");
 			var	chart = new Highcharts.Chart({
 		            chart: {
 		                renderTo: 'container',
 		                type: 'bar',
 		               backgroundColor: '#f4f3ef',
 		            },
 		            title: {
 		                text: 'Census'
 		            },
 		            xAxis: {
 		                categories: ['WHITE', 'BLACK OR AFRICAN AMERICAN', 'AMERICAN INDIAN AND ALASKA NATIVE', 'ASIAN', 'NATIVE HAWAIIAN AND OTHER PACIFIC ISLANDER','SOME OTHER RACE']
 		            },
 		            yAxis: {
 		                min: 0,
 		                title: {
 		                    text: 'Population'
 		                }
 		            },
 		            legend: {
 		                backgroundColor: '#f4f3ef',
 		                reversed: true
 		            },
 		            tooltip: {
 		                formatter: function() {
 		                    return ''+
 		                        this.series.name +': '+ this.y +'';
 		                }
 		            },
 		            plotOptions: {
 		                series: {
 		                    stacking: 'normal'
 		                }
 		            },
 		                series: [{
 		                name: 'Mortage',
 		                data: mortage
 		            }, {
 		                name: 'Clean',
 		                data: clean
 		            }, {
 		                name: 'Rent',
 		                data: rent
 		            }]
 		        });
 				
 			},'json');
 		}
        function convert(url)
        {
        	//url.replace("?","_#");
        	//url.replace("&","@#");
        	return url;
        }
        
        
        //Google MAP
        var geocoder;
  var map,places;
  function initialize() {
    geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(39.639538,-99.580078);
    var styledMap = new google.maps.StyledMapType(mapstyle,
    	    {name: "Styled Map"});
    var mapOptions = {
      zoom: 5,
      center: latlng,
      mapTypeControlOptions: {
          mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'map_style']
        }
    }
    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
    places = new google.maps.places.PlacesService(map);
    google.maps.event.addListener(map, "rightclick",function(event){showContextMenu(event.latLng);});
    google.maps.event.addListener(map, "click",function(event){$('.contextmenu').remove();});
    map.mapTypes.set('map_style', styledMap);
    map.setMapTypeId('map_style');
    loadStateShape();
  }
  
  function getCanvasXY(caurrentLatLng){
      var scale = Math.pow(2, map.getZoom());
     var nw = new google.maps.LatLng(
         map.getBounds().getNorthEast().lat(),
         map.getBounds().getSouthWest().lng()
     );
     var worldCoordinateNW = map.getProjection().fromLatLngToPoint(nw);
     var worldCoordinate = map.getProjection().fromLatLngToPoint(caurrentLatLng);
     var caurrentLatLngOffset = new google.maps.Point(
         Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale),
         Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)
     );
     return caurrentLatLngOffset;
  }
  function setMenuXY(caurrentLatLng){
    var mapWidth = $('#map_canvas').width();
    var mapHeight = $('#map_canvas').height();
    var menuWidth = $('.contextmenu').width();
    var menuHeight = $('.contextmenu').height();
    var clickedPosition = getCanvasXY(caurrentLatLng);
    var x = clickedPosition.x ;
    var y = clickedPosition.y ;

     if((mapWidth - x ) < menuWidth)
         x = x - menuWidth;
    if((mapHeight - y ) < menuHeight)
        y = y - menuHeight;

    $('.contextmenu').css('left',x  );
    $('.contextmenu').css('top',y );
    }
  
  
  function showContextMenu(caurrentLatLng  ) {
      var projection;
      var contextmenuDir;
      projection = map.getProjection() ;
      $('.contextmenu').remove();
          contextmenuDir = document.createElement("div");
        contextmenuDir.className  = 'contextmenu';
        contextmenuDir.innerHTML = "<a id='menu1'><div class=context><a href='javascript:whatshere("+caurrentLatLng.hb+","+caurrentLatLng.ib+");'>Where is here?</a><\/div><\/a><a id='menu2'><div class=context><a href='javascript:getLocalBusiness("+caurrentLatLng.hb+","+caurrentLatLng.ib+");'>Show local business</a><\/div><div><a href='javascript:evaluate("+caurrentLatLng.hb+","+caurrentLatLng.ib+")'>Evaluate Here</a></div><\/a>";
      $(map.getDiv()).append(contextmenuDir);
      
      setMenuXY(caurrentLatLng);

      contextmenuDir.style.visibility = "visible";
     }

  function codeAddress(address) {
    
    geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
       
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    });
  }
  function whatshere(lot,lat){
	  $('.contextmenu').remove();
	  var url="http://maps.googleapis.com/maps/api/geocode/json?latlng="+lot+","+lat+"&sensor=true";
      $.post("/WebService/ajax",{url:convert(url)},function(data1){
    	  var result=(data1.results)[0],address=(result.address_components)[2];
    	  var place=address.long_name;
    	  alert(place);
    	  
      },'json');
  }
  var auth = { 
		  //
		  // Update with your auth tokens.
		  //
		  /*
		  consumerKey: "de0WNr5Rp0TZKJewwXItaA", 
		  consumerSecret: "q-KAC3B3igYeqsNUwN13MwCfy8I",
		  accessToken: "LcYbZJBd1D3Bwtj6wWrCkuzaeaQyk58i",
		  // This example is a proof of concept, for how to use the Yelp v2 API with javascript.
		  // You wouldn't actually want to expose your access token secret like this in a real application.
		  accessTokenSecret: "hjlo0tEdeye7fijmEfDHaUQYHMw",*/
		  consumerKey: "qdTa32DN5GXphx9pujKiYw", 
		  consumerSecret: "6VfLIu1RW6qi4wUfQOCoLMj6zis",
		  accessToken: "YDkFPcLEa_CA-eg2imdK4UOBRMQTlUDI",
		  // This example is a proof of concept, for how to use the Yelp v2 API with javascript.
		  // You wouldn't actually want to expose your access token secret like this in a real application.
		  accessTokenSecret: "zytby3RvTGAt8n8PoAxd46bg26k",
		  serviceProvider: { 
		    signatureMethod: "HMAC-SHA1"
		  }
		};
  var yelpMarkerImage = {		  
		  size: new google.maps.Size(25, 31),
		  origin: new google.maps.Point(0, 0),
		  anchor: new google.maps.Point(12, 30),
		  url:"img/yelpMarker.png"
		};
  var yelpMarker=[];
  var yelpTipWin=null;
  function getLocalBusiness(lot,lat){
	  $('.contextmenu').remove();
    	  
    	  parameters = [];
    	  parameters.push(['term', generalCategory+"+"+subCategory]);
    	  parameters.push(['ll', lot+","+lat]);
    	  parameters.push(['sort', 1]);
    	  parameters.push(['callback', 'cb']);
    	  parameters.push(['oauth_consumer_key', auth.consumerKey]);
    	  parameters.push(['oauth_consumer_secret', auth.consumerSecret]);
    	  parameters.push(['oauth_token', auth.accessToken]);
    	  parameters.push(['oauth_signature_method', 'HMAC-SHA1']);
    	  var message = { 
    			  'action': 'http://api.yelp.com/v2/search',
    			  'method': 'GET',
    			  'parameters': parameters 
    			};
    	  var accessor = {
    			  consumerSecret: auth.consumerSecret,
    			  tokenSecret: auth.accessTokenSecret
    			};
    	  OAuth.setTimestampAndNonce(message);
    	  OAuth.SignatureMethod.sign(message, accessor);

    	  var parameterMap = OAuth.getParameterMap(message.parameters);
    	  parameterMap.oauth_signature = OAuth.percentEncode(parameterMap.oauth_signature);
    	  
    	 
    	  $.ajax({
    		  'url': message.action,
    		  'data': parameterMap,
    		  'cache': true,
    		  'dataType': 'jsonp',
    		  'jsonpCallback': 'cb',
    		  'success': function(data, textStats, XMLHttpRequest) {
    		    var business=data.businesses;
    		    for(var i=0;i<business.length;i++){
    		    	var b=business[i];
    		    	var loc=b.location.coordinate;
    		    	yelpMarker[i]=new google.maps.Marker({
    		              position:new google.maps.LatLng(parseFloat(loc.latitude),parseFloat(loc.longitude)),
    		              animation: google.maps.Animation.DROP,
    		              map: map,
    		              icon:yelpMarkerImage
    		            });
    		    	google.maps.event.addListener(yelpMarker[i], 'click', getYelpDetails(b, yelpMarker[i]));
    		    }
    			 
    		  }
    		});
    
     
  }
  function getYelpDetails(content,marker) {
	  return function() {
	  if (yelpTipWin!=null) {
		  yelpTipWin.close();
		  yelpTipWin = null;
        }

        	yelpTipWin = new google.maps.InfoWindow({
            content: "<div style='width:300px;'><div style='width:100px,height:100px;float:left;'><img src='"+content.image_url+"'></div><div style='width:195px;float:left;'><p style='margin-left:10px;margin-top:0;'>"+content.name+"<span style='color:#028E9B;font-size:14px;'>&nbsp;&nbsp;"+content.rating+"/5</span></p><p style='margin-left:10px;width:180px; max-height:57px; overflow-x:hidden;overflow-y:hidden;color:#333; font-size:12px;'>"+content.snippet_text+"</p></div></div>"
          });
        	yelpTipWin.open(map, marker);
        
	  }
    }
  var markers = new Array();
  var circle=new Array();
  for(var i=0;i<5;i++){
	  markers[i]=new Array();
	  circle[i]=new Array();
  }
  var color=["133CAB","D1006A","00CB00","A001A5","FF0000"];
  var icon=["deepBlue.png","pink.png","deepgreen.png","purple.png","red.png"];
  var index=-1;
  var flagimage = {		  
		  size: new google.maps.Size(25, 60),
		  origin: new google.maps.Point(0, 0),
		  anchor: new google.maps.Point(3, 57),
		};

  function search() {
	  index++;
	  var keywords=$("#keywordsInput").val();
	  var radius=0;
	  if($("#radiusInput").val()!="")
	  radius=parseInt($("#radiusInput").val());
	  
      var search = {
    	key:"AIzaSyA9wYURB1vV7LhTmatcZfva240mj6gPHpk",
    	query:keywords,
        bounds: map.getBounds()
      };
     
      places.textSearch(search, function(results, status) {
        if (status == google.maps.places.PlacesServiceStatus.OK) {
        	var letteredIcon = flagimage;
        	  letteredIcon.url = "img/" + icon[index];
          for (var i = 0; i < results.length; i++) {
            markers[index][i] = new google.maps.Marker({
              position: results[i].geometry.location,
              animation: google.maps.Animation.DROP,
              map: map,
              icon:letteredIcon
            });
            if(radius>0){
            var markercircle = {
            	      strokeColor: color[index],
            	      strokeOpacity: 0.25,
            	      strokeWeight: 2,
            	      fillColor: color[index],
            	      fillOpacity: 0.1,
            	      map: map,
            	      center: results[i].geometry.location,
            	      radius: radius
            	    };
            circle[index][i] = new google.maps.Circle(markercircle);
            google.maps.event.addListener(circle[index][i], "rightclick",function(event){showContextMenu(event.latLng);});
            google.maps.event.addListener(circle[index][i], "click",function(event){$('.contextmenu').remove();});
            }
        	
          }
        }
        
      });
    }
 var evaluateMarker=new Array();
 var evaluateInfoWIN;
function evaluate(lat,lot){
	$('.contextmenu').remove();
	$.post("/WebService/score",{longitude:lot,latitude:lat,superType:generalCategory,type:subCategory},function(data1){
  	  var  score=data1;
  	  var marker=new MarkerWithLabel({
          position: new google.maps.LatLng(parseFloat(lat),parseFloat(lot)),
          map: map,
          icon:getCircleIcon(data1.finalScore),
          labelContent: data1.finalScore,
          labelAnchor: new google.maps.Point(10,7),
          labelClass: "markerLabel", // the CSS class for the label
          labelInBackground: false
        });
  	  evaluateMarker.push(marker);
  	  google.maps.event.addListener(marker, 'click', getEvaluateInfo(data1, marker));
  	  /*
  	  var str=$("#scoreTable").html();
  	  str=str+"<tr><td>"+data1.prosperous+"</td><td>"+data1.need+"</td><td>"+data1.finalScore+"</td></tr>"
  		$("#scoreTable").html(str);*/
	},'json');
}
function getEvaluateInfo(content,marker) {
	  return function() {
	  if (evaluateInfoWIN!=null) {
		  evaluateInfoWIN.close();
		  evaluateInfoWIN = null;
      }

	  	evaluateInfoWIN = new google.maps.InfoWindow({
          content: "<div style='width:300px;height:150px;' class='evaluateWindow'><p>Prosperous: <span id='pstar'></span></p><p>Need: <span id='nstar'></span></p><p>Yelp average: <span id='ystar'></span></p><p >Final: <span id='astar'></span></p><p>Customer satisfactory: "+content.prob+" %</p></div>"
        });
      	evaluateInfoWIN.open(map, marker);
      	setTimeout(function() {
      	$('#pstar').raty({ readOnly: true, score: content.prosperous });
      	$('#nstar').raty({ readOnly: true, score: content.need });
      	$('#ystar').raty({ readOnly: true, score: content.rating });
      	$('#astar').raty({ readOnly: true, score: content.finalScore });
      	},100);
	  }
  }
function getCircleIcon(score) {
	  var circle = {
	    path: google.maps.SymbolPath.CIRCLE,
	    scale: score*2+10,
	    strokeColor: "#A61300",
	    strokeWeight: 2,
	    fillColor: 'red',
	   	fillOpacity: 0.8,
	  };
	  return circle;
}
var myOverlay = new Array();
var normalPolyStyle={
        strokeColor:"#0A67A3",
        strokeOpacity:0.7,
        strokeWeight:1,
        fillColor:"#5ccccc",
        fillOpacity: 0.3}
var hoverPolyStyle={
		strokeColor:"#0A67A3",
        strokeOpacity:0.7,
        strokeWeight:1,
        fillColor:"#FFF800",
        fillOpacity: 0.3
}
function loadCountyShape(stateCode){
	
	 $.ajax({
		  'url': "xml/"+stateCode+".xml",
		  'dataType': 'xml',
		  'success': function(xmlDoc) {
			  var data =[];
			  var county=$(xmlDoc).find("county");
			  county.each(function(i)
				{
						data.push($(this).children("rawdata").text());
						
				 });
					
				    
				    
			
				var pitCounty = new Array();
                pitCounty = createOverlay(data);
                for(var k=0;k<data.length;k++){
                pitCounty[k].setMap(map);
                var county_id=$(county[k]).children("county_id").text();
                var state_id=$(county[k]).children("state_id").text();
                var county_name=$(county[k]).children("county_name").text();
                pitCounty[k].set("county",county_id);
                pitCounty[k].set("state",state_id);
                pitCounty[k].set("countyName",county_name);
                google.maps.event.addListener(pitCounty[k], "click",function(){
                	report("&for=county:"+this.get("county")+"&in=state:"+this.get("state"),this.get("countyName"));
                	map.setZoom(11);
                });
                google.maps.event.addListener(pitCounty[k], "mouseover",function(){
             	   this.setOptions(hoverPolyStyle);
                });
                google.maps.event.addListener(pitCounty[k], "mouseout",function(){
             	   this.setOptions(normalPolyStyle);
                });
                }
			 
		  }
		});
}
function loadStateShape(){
	 $.ajax({
		  'url': "xml/all.xml",
		  'dataType': 'xml',
		  'success': function(xmlDoc) {
			  var data =[];
			  var state=$(xmlDoc).find("county");
			  state.each(function(i)
				{
						data.push($(this).children("rawdata").text());
						
				 });
					
				    
				    
			
				var pitCounty = new Array();
               pitCounty = createOverlay(data);
               for(var k=0;k<data.length;k++){
               pitCounty[k].setMap(map);
               var county_id=$(state[k]).children("county_id").text();
               var state_id=$(state[k]).children("state_id").text();
               var state_code=$(state[k]).children("state_code").text();
               pitCounty[k].set("stateName",county_id);
               pitCounty[k].set("state",state_id);
               pitCounty[k].set("stateCode",state_code);
               google.maps.event.addListener(pitCounty[k], "click",function(){
            	   state=this.get("stateCode");
            	   codeAddress(this.get("stateName"));
            	   loadCountyShape(this.get("state"));
            	   map.setZoom(7);
            	   showTrends(state);
               });
               google.maps.event.addListener(pitCounty[k], "mouseover",function(){
            	   this.setOptions(hoverPolyStyle);
               });
               google.maps.event.addListener(pitCounty[k], "mouseout",function(){
            	   this.setOptions(normalPolyStyle);
               });
               }
			 
		  }
		});
}

function createOverlay(data){
	clearRegion(myOverlay);
    for(var j=0;j<data.length;j++){
    var overlayCoords = new Array();
    var processedData = data[j].split(";");
    for(var i =0; i<processedData.length; i++){
        var xyCoords = processedData[i].split(",");
        overlayCoords.push(new google.maps.LatLng(xyCoords[0],xyCoords[1]));
    }
 
    myOverlay[j] = new google.maps.Polygon({
                                            paths: overlayCoords
                                            });
    myOverlay[j].setOptions(normalPolyStyle);
    
}
    return myOverlay;
}
function clearRegion(array){
	for(var i=0;i<array.length;i++){
		array[i].setMap(null);
    	
    }
	array = new Array();
}
function showSlide(){
	$("#sliderDiv").animate({left:'0px'});
}
function hideSlide(){
	$("#sliderDiv").animate({left:'-960px'});
}
function searchFocus(){
	$("#searchAress").val("");
}
function searchBlur(){
	if($("#searchAress").val()==""){
		$("#searchAress").val("Search an address");
	}
}
function showTrends(state){
	var str="<iframe width='400' height='400' src='//www.google.com/trends/fetchComponent?hl\75en-US\46q\75"+subCategory+"+"+generalCategory+",+\46geo\75US-"+state+"\46cmpt\75q\46content\0751\46cid\75TIMESERIES_GRAPH_0\46export\0755\46w\075400\46h\075400' style='border: none;'></iframe>";
	//str=str+"<iframe width='500' height='330' src='//www.google.com/trends/fetchComponent?hl\75en-US\46q\75"+subCategory+"+"+generalCategory+",+\46geo\75US-"+state+"\46cmpt\75q\46content\0751\46cid\75TOP_QUERIES_0_0\46export\0755\46w\075300\46h\075420' style='border: none;'></iframe>";
	str=str+"<iframe width='500' height='450' src='//www.google.com/trends/fetchComponent?hl\75en-US\46q\75"+subCategory+"+"+generalCategory+",+\46geo\75US-"+state+"\46cmpt\75q\46content\0751\46cid\75GEO_MAP_0_0\46export\0755\46w\075500\46h\075450' style='border: none;'></iframe>";
	
	$("#trendDiv").html(str);
	
}
function cencus(){
	$("#container").show();
	$("#trendDiv").hide();
	showSlide();
}
function trends(){
	$("#container").hide();
	$("#trendDiv").show();
	showSlide();
}
function resetCensus(){
	clearRegion(myOverlay);
	var latlng = new google.maps.LatLng(39.639538,-99.580078);
	map.setCenter(latlng);
	map.setZoom(5);
	loadStateShape();
}
function resetDistance(){
	index=-1;
	for(var i=0;i<markers.length;i++){
		clearRegion(markers[i]);
	}
	for(var i=0;i<circle.length;i++){
		clearRegion(circle[i]);
	}
	
}
function resetBusiness(){
	clearRegion(yelpMarker);
}
function resetEvaluate(){
	clearRegion(evaluateMarker);
}
</script>
</head>
<body style="margin:0;padding:0;background-color:#f4f3ef;">




<div style="width:1280px;">
<div style="width:1270px;height:47px;background-color:#f4f3ef;padding-top:5px;padding-left:10px;"></div>
<div id="map_canvas" style="width: 1280px; height: 510px;"></div>

<div style="width:1270px;height:47px;background-color:#f4f3ef;padding-top:5px;padding-left:10px;box-shadow: 0px 5px 5px #555;position:absolute; top:0;left:0;"><div style="float:left;width:300px;"><img src="img/logo.png" style="height:40px;"></div><div style="float:right; padding-right:20px;padding-top:10px;"><input type="text" value="Search an address" id="searchAress" onFocus="searchFocus()" onBlur="searchBlur()" /></div></div>
<!--  
<script type="text/javascript" src="//www.google.com/trends/embed.js?hl=en-US&q=Chinese+restaurant,+&geo=US&cmpt=q&content=1&cid=TIMESERIES_GRAPH_0&export=5&w=500&h=330"></script>
<script type="text/javascript" src="//www.google.com/trends/embed.js?hl=en-US&q=Chinese+restaurant,+&geo=US&cmpt=q&content=1&cid=GEO_MAP_0_0&export=5&w=500&h=530"></script>
<script type="text/javascript" src="//www.google.com/trends/embed.js?hl=en-US&q=Chinese+restaurant,+&geo=US&cmpt=q&content=1&cid=TOP_QUERIES_0_0&export=5&w=300&h=420"></script>
-->

<div class="buttomPanel">
<span> <a href="javascript:cencus()">Census </a></span><span> <a href="javascript:trends()">Trends</a> </span>
<span>
<d class="queryDiv">
Keyword: 
<input type="text" id="keywordsInput" />&nbsp;&nbsp;&nbsp;&nbsp;Distance: <input type="text" id="radiusInput" />
</d>
</span>
<span>Reset: <a class='reset' href="javascript:resetCensus()">Census</a>  <a class='reset' href="javascript:resetDistance()">Distance</a>  <a class='reset'  href="javascript:resetBusiness()">Business</a>  <a class='reset'  href="javascript:resetEvaluate()">Evaluation</a></span>
</div>


<div id="sliderDiv">
<div style="float:left; width:900px;height:510px;">
<div id="container" style="display:none; height: 400px; margin-top:50px;width:880px;"></div>
<div id="trendDiv" style="display:none;"></div>
</div>
<div style="float:left;width:40px;font:archery black;height:310px;padding-top:200px;">
<a href="javascript:hideSlide()">
<img src="img/leftarrow.png" width="35" height="100"/>
</a>
</div>
</div>
</div>



</body>
</html>