<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.net.URL"%>

<%@ taglib prefix="mvc" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>



<mvc:layout>
	<div class="row mt20">
		<div class="" id="mytimeline"></div>
		<select class="shown" id="expList">
		</select>		
	</div>
	<div class="row ">
		<div id="map" class="" style="width: 98%; height: 400px;"></div>
	</div>
	<div class="row mt20">
		<div class="span12">
			<p class="text-right">
				위쪽의 답사목록에서 살펴볼 <b>답사</b>를 선택하고 지도를 <b>확대</b>해주세요.
			</p>
			<p class="text-right">
				지도를 확대하면 답사코스마다 <b>원고</b>를 볼 수 있는 창이 나옵니다.
			</p>
		</div>
	</div>
	<div id="info_layer"
		style="position: absolute; z-index: 1; visibility: hidden; background-color: white; border: 1px solid rgb(118, 129, 168);"></div>
</mvc:layout>
<link href='/resources/css/timeline.css' rel='stylesheet'>
<script type="text/javascript" src="/resources/js/jsapi.js"></script>


<script type="text/javascript"
	src="http://apis.daum.net/maps/maps3.js?apikey=<%if (request.getRequestURL().indexOf("localhost") > 0) {
				out.println("6c13f58768d31117a58c2f22987480f571be6119");
			} else if (request.getRequestURL().indexOf("112.144.52.47") > 0) {
				out.println("77feee1a3fbda67581bb312b65542efdc491bb53");
			} else if (request.getRequestURL().indexOf("192.168.123.123") > 0) {
				out.println("f03a680015b716daf3e13c51fceb33569702bcbe");
			} else if (request.getRequestURL().indexOf("lifenjoys.cafe24.com") > 0) {
				out.println("f023afc03c5e6b53c97a80caae1b437be7336c82");
			}%>"
	charset="utf-8"></script>
<script src='/resources/js/timeline.js'></script>

<script type="text/javascript">
	var map; //다음맵

	var idxs = new Array(); //답사 고유번호
	var path = new Object(); //위치정보들
	var lines = new Object(); //위치간 선
	var markers = new Object(); //위치에 찍힌 마커
	var infowindows = new Object(); //위치에 대한 정보
	var curIdx; //현재 선택한 답사
	var siteCnt = 0; //답사안에 있는 위치 개수
	var layer = document.getElementById("info_layer");
	var site_mode;
	//var expList = new Array();	//셀렉트박스 생성을 위한 답사정보 보관배열

	//timeline object
	var timeline;
	google.load("visualization", "1");

	// Set callback to run when API is loaded
	google.setOnLoadCallback(doMain);

	$(document).ready(
			function() {
				$(window).resize(resizeMap); 
				resizeMap();
				map = new daum.maps.Map(document.getElementById('map'), {
					center : new daum.maps.LatLng(37.50587670225458,
							126.95551351374866),
					level : 4
				});

				var zoomControl = new daum.maps.ZoomControl();
				map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
				var mapTypeControl = new daum.maps.MapTypeControl();
				map.addControl(mapTypeControl,
						daum.maps.ControlPosition.TOPRIGHT);

				//daum.maps.event.addListener(map, "zoom_changed", fnChkMarkers);
				//daum.maps.event.addListener(map,"bounds_changed",fnChkMarkers);

				//daum.maps.event.addListener(map, 'drag',hiddenInfoLayer);
				daum.maps.event.addListener(map, 'bounds_changed',hiddenInfoLayer);
				//daum.maps.event.addListener(map, "zoom_changed", hiddenInfoLayer);

				var UserAgent = navigator.userAgent;
				 
				if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null)
				{
					site_mode = "mobile";
					drawMobilePage();
				}else{
					site_mode = 'web';
				}
			});
	
	function drawMobilePage(){
		$('#mytimeline').css("display", "none");
		$('#map').css("width", "100%");
		$('#expList').css("display", "block");
		$('#expList').css("width", "100%");
	}
	
	function resizeMap(){
		 var h = $(window).height();
		 var w= $(window).width();
		 document.getElementById('map').style.height=(h*3/5)+'px';
		
	}

	// Called when the Visualization API is loaded.
	function drawVisualization(expList) {

		// Create and populate a data table.
		var data = new google.visualization.DataTable();
		data.addColumn('datetime', 'start');
		data.addColumn('string', 'content');
		//data.addColumn('datetime', 'end');

		data.addRows(expList);

		// specify options
		options = {
			"width" : "98%",
			"height" : "145px",
			"style" : "box",
			"min" : new Date(1990, 1, 1),
			"max" : new Date(2020, 12, 31),
			"zoomable" : true,
			"scale" : links.Timeline.StepDate.SCALE.YEAR,
			"step" : 1,
			"locale" : "kr",
			"showNavigation" : true,
			"eventMarginAxis":5,
			"eventMargin":5,
			'showMajorLabels': false,
	        'showMinorLabels': true
				

		};

		// Instantiate our timeline object.
		timeline = new links.Timeline(document.getElementById('mytimeline'));

		// Draw our timeline with the created data and options
		timeline.draw(data, options);
	}

	function drawMarkers() {
		for ( var i = 0; i < siteCnt; i++) {

			markers[curIdx][i].setMap(map);

			//마커클릭시 정보제공
			daum.maps.event.addListener(markers[curIdx][i], "click",
					function() {
						layer.innerHTML = '';	//레이어비우기
						var chkTouch;
						try{
							chkTouch = event instanceof TouchEvent;
						}catch(e){
							chkTouch = false;
						}
						
						if(chkTouch){
							layer.style.top = event.changedTouches.item(0).pageY + 'px';
							layer.style.left = event.changedTouches.item(0).pageX + 'px';
						}else{
							layer.style.top = event.clientY + 'px';
							layer.style.left = event.clientX + 'px';
						}
						
						var markerIdx = this.getTitle();
						var obj = path[curIdx][markerIdx];

						var div = document.createElement('ul');
						var head = document.createElement('h5');
						head.className = 'infowindow-title';
						head.innerHTML = obj.site_name;
						div.className = 'map-infowindow';
						div.appendChild(head);

						$.ajax({
							url : "heritageList",
							type : 'post',
							dataType : 'json',
							data : 'site_idx=' + obj.site_idx,

							beforeSend : function() {
							},

							success : function(json) {
								$.each(json.list, function(j, heritage) {

									var li = document.createElement('li');
									li.id = heritage.heritage_idx;
									li.className = 'ml25 infowindow-text';
									li.innerHTML = heritage.heritage_name;
									li.style.cursor = 'pointer';

									li.setAttribute('onclick',
											'window.open(\"/exp/getText?heritage_idx='
													+ heritage.heritage_idx
													+ '\");'); //임시경로
									var icon = document.createElement('i');
									icon.className = 'icon-list-alt';
									icon.style.margin = '-2px 0 0 3px';
									li.appendChild(icon);
									div.appendChild(li);
									//div.appendChild(icon);
								});
							},

							complete : function() {
								//infowindows[curIdx][markerIdx].setContent(div);
								//infowindows[curIdx][markerIdx].open(map, markers[curIdx][markerIdx]);
								layer.appendChild(div);
								setInfoLayer();

							}

						});
					});
		}
	}
	
	function hiddenInfoLayer(){
		layer.style.visibility = "hidden";
	}	
	
	function setInfoLayer(){
		layer.style.visibility = "visible";
	}

	function removeMarkers() {
		for ( var i = 0; i < siteCnt; i++) {
			markers[curIdx][i].setMap(null);
			infowindows[curIdx][i].close();
			if (i > 0) {
				lines[curIdx][i].setMap(null);
			}

		}
	}

	function fnJsonData(json) {
		var data = new Array();
		$.each(json.list, function(i, obj) {
			idxs[i] = obj.exp_idx;
			data[i] = new Array();
			data[i][0] = new Date(obj.start_year, obj.start_month,
					obj.start_day);
			data[i][1] = "<span style=\'cursor : pointer\'>" + obj.exp_name
					+ "</span>";
			//data[i][2] = new Date(obj.end_year, obj.end_month, obj.end_day);
		});

		return data;
	}

	function fnDrawPath(idx) {
		$.ajax({
			url : "expInfoPath",
			type : 'post',
			dataType : 'json',
			data : 'idx=' + idx,

			beforeSend : function() {
				//fnChkMarkers();
				removeMarkers();
			},

			success : function(json) {
				// 빈 LatLngBounds 객체 생성
				var bounds = new daum.maps.LatLngBounds();
				//마킹할 위치정보 개수 초기화
				siteCnt = 0;
				//현재 선택된 idx저장
				curIdx = idx;

				$.each(json.list, function(i, obj) {

					path[idx][siteCnt] = obj;
					var coord = new daum.maps.LatLng(obj.latitude,
							obj.longitude);

					// 해당 좌표에 marker 올리기
					var marker = new daum.maps.Marker({
						position : coord
					});
					marker.setTitle(siteCnt);
					markers[idx][siteCnt] = marker;
					//marker.setMap(map);

					var infowindow = new daum.maps.InfoWindow({
						removable : true
					});

					infowindows[idx][siteCnt] = infowindow;

					// LatLngBounds 객체에 해당 좌표들을 포함
					bounds.extend(coord);

					//라인 그리기
					if (siteCnt > 0) {
						var line = new daum.maps.Polyline({
							endArrow : true,
							strokeWeight : 6,
							strokeColor : '#3399FF',
							strokeOpacity : 0.6,
							fillColor : '#0099ff',
							fillOpacity : 0.3

						});
						lines[idx][siteCnt] = line;//선 저장

						line.setPath([
								new daum.maps.LatLng(
										path[idx][siteCnt - 1].latitude,
										path[idx][siteCnt - 1].longitude),
								new daum.maps.LatLng(obj.latitude,
										obj.longitude) ]);
						line.setMap(map);
					}

					siteCnt++; //사이트개수 카운트
				});

				// 좌표가 채워진 LatLngBounds 객체를 이용하여 지도 영역을 확장
				map.setBounds(bounds);
			},

			complete : function() {
				drawMarkers();
			}

		});
	}

	function doMain() {
		//요청
		$.ajax({
			url : "expInfoSimpleList",
			type : 'post',
			dataType : 'json',
			beforeSend : function() {
			},

			success : function(json) {
				var data = fnJsonData(json);
				drawVisualization(data);

				$.each(json.list, function(i, obj) {
					path[obj.exp_idx] = new Array();
					lines[obj.exp_idx] = new Array();
					markers[obj.exp_idx] = new Array();
					infowindows[obj.exp_idx] = new Array();
					 
					$("<option />", {
						value: obj.exp_idx, 
						text: obj.exp_name}
					).appendTo($('#expList'));
				});

				google.visualization.events.addListener(timeline, 'select',
				function() {
					var sel = timeline.getSelection();
					if (sel.length) {
						if (sel[0].row != undefined) {
							var row = sel[0].row;
							fnDrawPath(idxs[row]);
						}
					}
				});
			},

			complete : function() {
				$('#expList').change(function(){
			       var idx = $("#expList option:selected").val();
			       fnDrawPath(idx);
			    });
			}

		});

	};
</script>