<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.net.URL"%>

<%@ taglib prefix="mvc" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<mvc:layout>
<div class="row">
	<div class="page-header">
		<h3>코스정보입력</h3>
	</div>
	<div class="span5">
		<div class="row">
			<div class="control-group  input-append span5">
				<form id="site_info_search_form">
				<div class="controls text-right">
						<select class="spanb mr10" id="search_type" name="search_type">
						  <option value='name'>답사장소</option>
						  <option value='type'>유형</option>
						  <option value='region'>지역</option>
						</select>
						<input class="span2" type="text" id="search_query" name="search_query" value="">
						<button class="btn" id="srch_btn" type="button" onclick="javascript:getExpSiteList(1);"><b>검색</b></button>
						
						<input type="hidden" id="total_cnt" name="total_cnt" value="1"/>
						<input type="hidden" id="current_page" name="current_page" value=""/>
						<input type="hidden" id="rows_per_page" name="rows_per_page" value="16"/>
    					<input type="text" style="display: none;" />
				</div>
				</form>
			</div>
		</div>
		<div class="row">
		<table class="table table-striped table-bordered table-hover table-condensed">
			<thead>
				<tr>
					<th>순번</th>
					<th>유형</th>							
					<th>답사장소</th>							
					<th>지역</th>
				</tr>
			</thead>
			<tbody id="list_body">
			</tbody>
		</table>
		</div>
		<div class="row center">
			<div id="Pagination" class="pagination"></div>
        </div>
	</div>
	<div class="span7">
	<form class="form-horizontal mt10 row margin" id="site_info_form">	
	<div class="row">	
		<div  class="span4">
			<div class="control-group">
				<label class="control-label" for="site_name">답사장소</label>
				<div class="controls">
					<input class="span3 required" type="text" id="site_name" name="site_name" placeholder="ex) 08 추계답사" readonly="readonly">
					
				</div>
			</div>
			<div class="control-group ">
				<label class="control-label" for="addr">주소</label>
				<div class="controls">
					<input type="text" class="span3 required" id="addr" name="addr" placeholder="" readonly="readonly">
				</div>
			</div>
			<div class="control-group  input-append">
				<label class="control-label" for="site_name">지도검색</label>
				<div class="controls">
					<input class="span2" type="text" id="addr_search_query" name="addr_search_query" >
					<button class="btn" id="srch_btn" type="button" onclick="javascript:searchAddr();"><b>검색</b></button>
					
				</div>
			</div>
		</div>
		<div  class="span3">
			<div class="control-group">
				<label class="control-label" for="site_type">유형</label>
				<div class="controls">
					<select class="spanb" id="site_type" name="site_type">
					  <option value='1'>유적</option>
					  <option value='2'>숙소</option>
					  <option value='3'>식당</option>
					</select>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="coord">위도</label>
				<div class="controls">
					<input type="text" class="span1 required" id="latitude" name="latitude" value="" placeholder="" readonly="readonly">
					<input type="text" class="span1 required" id="longitude" name="longitude" value="" placeholder="" readonly="readonly">
				</div>
			</div>
		</div>
			<div class="control-group text-right">
				<button class="btn btn-success shown" id="heritage_add_btn" type="button" onclick="javascript:addHeritage();"><b>유산등록</b></button>
				<button class="btn btn-warning" id="new_btn" type="button" onclick="javascript:newExpSite();"><b>신규</b></button>
				<button class="btn btn-success shown" id="add_btn" type="button" onclick="javascript:insExpSite();"><b>등록</b></button>
				<button class="btn btn-primary shown" id="upd_btn" type="button" onclick="javascript:updExpSite();"><b>수정</b></button>
				<button class="btn btn-danger shown" id="del_btn" type="button" onclick="javascript:delExpSite();"><b>삭제</b></button>
			</div>
			<input type="hidden" id="site_idx" name="site_idx" value=""/>
			<input type="hidden" id="region" name="region" value=""/>
			<input type="hidden" id="city" name="city" value=""/>
			<input type="hidden" id="_method" name="_method" value=""/>
	</div>
	</form>
	<div class="row-fluid">		
		<div id="map" class="span12 h400"></div>
	</div>		
	</div>
</div>
<span id="txtContent"></span>
<span id="info"></span>
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
	var map;	//다음맵
	var addMode=false;
	var updMode=false;
	var current_page=1;
	var addrArray = new Array();
	var markers = new Array();
	var infowindows = new Array();
	var markerCnt = 0;
	
	$(document).ready(function() {
		getExpSiteList(1);
		setKeyEvent();
		
		map = new daum.maps.Map(document.getElementById('map'), {
			center : new daum.maps.LatLng(37.50587670225458, 126.95551351374866),
			level : 4
		});
		
		var zoomControl = new daum.maps.ZoomControl();
		map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
		var mapTypeControl = new daum.maps.MapTypeControl();
		map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);
		
		//맵을 더블클릭하면 주소와 좌표를 넣는다.
		daum.maps.event.addListener(map,"dblclick",function(){
		
			var center = map.getCenter();
			$('#latitude').val(parseFloat(center.getLat()).toFixed(4));
			$('#longitude').val(parseFloat(center.getLng()).toFixed(3));
			$.getJSON('siteInfoAddrCoord?x='+center.getLat()+'&y='+center.getLng(), function(data) {
					var obj = data["com.lifenjoys.exp.mod.AddrCoord"];
				  
					$('#region').val(obj.region);
					$('#city').val(obj.city);
					$('#addr').val(obj.addr);
				});
			
		});
	});
	
	function setKeyEvent(){
		$("#search_query").keydown(function(event) {
		   if(event.keyCode == 13) getExpSiteList(1);
		});
		
		$("#addr_search_query").keydown(function(event) {
		   if(event.keyCode == 13) searchAddr();
		});
	}
	
	function enableEdit(){
		$('#site_name').removeAttr('readonly');
	}
	
	function disableEdit(){
		$('#site_name').attr('readonly','true');
	}
	
	function drawPaging(page){
		current_page = page;
        var pg = $("#Pagination").paging({
    		obj_id:'paging',
        	current_page: page,
        	total_cnt : $('#total_cnt').val(),
    		rows_per_page:$('#rows_per_page').val(),
    		num_display_entries:10,
        	user_function: 'getExpSiteList'
        });
	}	
	
	function initForm(){
		$('#site_idx').val('');
		$('#site_name').val('');
		$("#site_type").val('');
		$('#addr').val('');
		$('#region').val('');
		$('#city').val('');
		$('#latitude').val('');
		$('#longitude').val('');
		initMap();
	}
	
	/**
	 * 코스정보 신규
	 */
	function newExpSite(){
		if(addMode){
			if(!confirm('입력하던 내용을 버리고 새로 입력하시겠습니까?')) return;
		}else{
			if(!confirm('새로운 코스정보를 입력하시겠습니까?')) return;
		}
		addMode = true;	//입력모드 시작
		updMode = false;
		enableEdit();
		initForm();	//입력폼 초기화
		$('#add_btn').removeClass('shown');
		$('#upd_btn').addClass('shown');
		$('#heritage_add_btn').addClass('shown');
		$('#del_btn').addClass('shown');
	}

	/**
	 * 코스정보 입력
	 */
	function insExpSite() {
		if(!fnValidate()) return; //검증
		if(!confirm('코스정보를 등록하시겠습니까?')) return;
		
		$("#_method").val('POST');
		var params = $("#site_info_form").clone()	//입력시엔 idx삭제하고 파라미터 생성
        .find("#site_idx").remove()
        .end().serialize();
		
		$.ajax({ 
			url : "siteInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if(json.int>0){
					alert('입력되었습니다.');
					getExpSiteList(current_page);
					addMode=false;
				}else{
					alert('입력과정에 문제가 발생했습니다.');
				};
			},
		});
	}

	/**
	 * 코스정보 수정
	 */
	function updExpSite() {
		if(!fnValidate()) return; //검증
		if(!confirm('코스정보를 수정하시겠습니까?')) return;
		
		$("#_method").val('PUT');
		var params = $("#site_info_form").serialize();
		
		$.ajax({ 
			url : "siteInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if(json.int>0){
					alert('수정되었습니다.');
					getExpSiteList(current_page);
					updMode = false;					
				}else{
					alert('수정과정에 문제가 발생했습니다.');
				};
			},
		});
	}

	/**
	 * 코스정보 삭제
	 */
	function delExpSite() {
		if(!confirm('코스정보를 삭제하시겠습니까?')) return;
		
		$("#_method").val('DELETE');
		var params = $("#site_info_form").serialize();
		console.log('delete params -> '+params);
		
		$.ajax({ 
			url : "siteInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if(json.int>0){
					alert('삭제되었습니다.');
					getExpSiteList(current_page);
					updMode = false;			
				}else{
					alert('삭제과정에 문제가 발생했습니다.');
				};
			},
		});
	}
	
	/*
	* 입력폼 유효성 검증
	*/
	function fnValidate(){
		$("#site_info_form").validate();
		return $("#site_info_form").valid();		
	}
	
	/*
	* 답사 상세정보 조회
	*/
	function getExpSite(siteIdx){
		if(addMode){
			if(!confirm('입력중인 내용이 사라집니다. 진행할까요?')) return;
		}
		
		//에러메세지 초기화
		$('label.error').addClass('shown');
		//상세정보읽기
		$('#site_idx').val(siteIdx);
		$('#site_name').val($('#'+siteIdx+'_name').text());
		$('#addr_search_query').val($('#'+siteIdx+'_name').text());	//지도검색어에 자동등록
		
		$("#site_type").val($('#'+siteIdx+'_type').attr('value'));
		$('#addr').val($('#'+siteIdx+'_region').attr('addr'));
		$('#latitude').val($('#'+siteIdx+'_region').attr('latitude'));
		$('#longitude').val($('#'+siteIdx+'_region').attr('longitude'));
		$('#region').val($('#'+siteIdx+'_region').attr('region'));
		$('#city').val($('#'+siteIdx+'_region').attr('city'));
		
		
		$('#add_btn').addClass('shown');
		$('#upd_btn').removeClass('shown');
		$('#heritage_add_btn').removeClass('shown');		
		$('#del_btn').removeClass('shown');
		addMode = false;
		updMode = true;
		enableEdit();
		map.panTo(new daum.maps.LatLng($('#'+siteIdx+'_region').attr('latitude'), $('#'+siteIdx+'_region').attr('longitude')));
		map.setLevel(2);
	};
	
	/*
	* 코스정보 목록 조회
	*/
	function getExpSiteList(page){
		$('#list_body').empty();
		$('#current_page').val(page);
		var params = "";
		params += "total_cnt="+$('#total_cnt').val();
		params += "&current_page="+$('#current_page').val();
		params += "&rows_per_page="+$('#rows_per_page').val();
		params += "&search_query="+$('#search_query').val();
		params += "&search_type="+$('select[name="search_type"]').val();
		params = encodeURI(params);
		console.log(params);
		
		$.ajax({ 
			url : "siteInfoList",
			type : 'GET',
			dataType : 'json',
			data : params,
			async : false,
			success : function(json) {
				$.each(json.list, function(i, siteInfo) {
					$('<tr/>', {
						'class' : 'cursorp',
						'onClick' : "javascript:getExpSite("+siteInfo.site_idx+");"
					}).append($('<td/>', {
						id:siteInfo.site_idx+'_idx',
						html : siteInfo.site_idx
					})).append($('<td/>', {
						id:siteInfo.site_idx+'_type',
						value:siteInfo.site_type,
						html : siteInfo.site_type_name
					})).append($('<td/>', {
						id:siteInfo.site_idx+'_name',
						html : siteInfo.site_name
					})).append($('<td/>', {
						id:siteInfo.site_idx+'_region',
						addr:siteInfo.addr,
						latitude:parseFloat(siteInfo.latitude).toFixed(4),
						longitude:parseFloat(siteInfo.longitude).toFixed(3),
						region:siteInfo.region,
						city:siteInfo.city,
						html : siteInfo.region
					})).appendTo('#list_body');
					$('#total_cnt').val(siteInfo.total_cnt);
				});
			},
			complete:function(){
				drawPaging(page);
				disableEdit();
				initForm();
				$('#add_btn').addClass('shown');
				$('#upd_btn').addClass('shown');
				$('#heritage_add_btn').addClass('shown');
				$('#del_btn').addClass('shown');
			}
		});
		
	}
	
	function initMap(){
		for ( var i = 0; i < markerCnt; i++) {
			try{
			markers[i].setMap(null);
			infowindows[i].close();
			}catch(e){}
			
		}
		markerCnt = 0;
		
	}
	
	function searchAddr(){
		initMap();
		var searchQuery = $('#addr_search_query').val()
		var tmp = searchQuery.indexOf('(');
		if(tmp>0){
			searchQuery = searchQuery.substring(0, tmp);
		}
		
		$.ajax({
			url : "siteInfoAddr",
			type : 'post',
			dataType : 'json',
			data : 'site=' + searchQuery,
			success : function(json) {
				// 빈 LatLngBounds 객체 생성
				var bounds = new daum.maps.LatLngBounds();
				
				$.each(json.list, function(i, obj) {

					addrArray[i]= obj;
					var coord = new daum.maps.LatLng(obj.latitude,
							obj.longitude);

					// 해당 좌표에 marker 올리기
					var marker = new daum.maps.Marker({
						position : coord
					});
					marker.setTitle(i);
					
					markers[i] = marker;
					markers[i].setMap(map);
					

					var infowindow = new daum.maps.InfoWindow({
						removable : true
					});

					var div = document.createElement('div');
					var head = document.createElement('h4');
					head.innerHTML = obj.name;
					div.appendChild(head);				
					div.className = 'dropdown-toggle';
					
					var p = document.createElement('p');
					if(obj.desc!=''){
						p.innerHTML = obj.desc;
						div.appendChild(p);
					}
					
					infowindow.setContent(div);
					infowindows[i] = infowindow;
					//infowindow.open(map, marker);
					
					// LatLngBounds 객체에 해당 좌표들을 포함
					bounds.extend(coord);
					daum.maps.event.addListener(marker, "click", function(){

						var i = this.getTitle();
						var obj = addrArray[i];						
						
						infowindows[i].open(map, markers[i]);
						$('#addr').val(obj.addr);
						$('#latitude').val(parseFloat(obj.latitude).toFixed(4));
						$('#longitude').val(parseFloat(obj.longitude).toFixed(3));
						$('#region').val(obj.region);
						$('#city').val(obj.city);
					});
					markerCnt++;
					
				});

				// 좌표가 채워진 LatLngBounds 객체를 이용하여 지도 영역을 확장
				map.setBounds(bounds);
			}
		});
	}
	
	function addHeritage(){
		if(!confirm($('#site_name').val()+'에 대한 문화유산 입력 페이지로 이동하시겠습니까?'))return;
		location.href = "heritageInfo?site_idx="+$('#site_idx').val()+"&site_name="+$('#site_name').val();
	}
</script>