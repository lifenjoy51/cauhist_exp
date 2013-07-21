<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.net.URL"%>

<%@ taglib prefix="mvc" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<mvc:layout>

	<h3>답사-코스 연결</h3>
<div class="row">
	<div id="mytimeline"></div>
</div>
<div class="row mt20">
	<!-- 답사코스검색영역 -->
	<div class="control-group span5">
		<form class="margin text-right" id="site_info_search_form">
		<div class="controls input-append">
				<select class="spana mr10" id="search_type" name="search_type">
				  <option value='name'>이름</option>
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
		<div class="row">
			<table class="table table-striped table-bordered table-hover table-condensed">
				<thead>
					<tr>
						<th>순번</th>
						<th>유형</th>							
						<th>답사장소</th>							
						<th>지역</th>
						<th>선택</th>
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
	
	<!-- 컨트롤 인터페이스 -->
	<div class="span2 text-center">
		<div class="row mt100 mb30 pr15">
			<span class="arrow-danger cursorp" rel='90' onclick="addSites();"></span>			
		</div>
	</div>
	
	<!-- 코스가 추가될영역 -->
	<div class="margin span5">
		<div class="row-fluid">
			<div class="span5">
				<input type="hidden" id="exp_idx" name="exp_idx" value=""/>
				<h4 id='selected_exp' style="margin:0 0 18px 0;"><i class="icon-ok-circle"></i></h4>
			</div>
			<div class="span7 text-right">
				<button class="btn btn-warning shown" id="new_btn" type="button" onclick="javascript:newExpSite();"><b>신규</b></button>
				<button class="btn btn-success" id="add_btn" type="button" onclick="javascript:insExpSite();"><b>저장</b></button>
				<button class="btn btn-primary shown" id="upd_btn" type="button" onclick="javascript:updExpSite();"><b>수정</b></button>
				<button class="btn btn-danger shown" id="del_btn" type="button" onclick="javascript:delExpSite();"><b>삭제</b></button>
			</div>
		</div>
		<div class="row">
			<table class="table table-bordered table-hover table-condensed">
				<thead>
					<tr>
						<th>순번</th>
						<th>유형</th>							
						<th>답사장소</th>							
						<th>지역</th>
						<th class="text-center">순서</th>
					</tr>
				</thead>
				<tbody id="list_body_second">
				</tbody>
			</table>
		</div>
	</div>
</div>
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
	var siteList = new Array(); //위치정보들
	var srcSiteList = new Array(); //등록기반이 되는 답사코스 리스트
	var curIdx; //현재 선택한 답사
	var siteCnt = 1; //답사안에 있는 위치 개수 1부터시작
	
	//timeline object
	var timeline;
	var timelineData;
	
	google.load("visualization", "1");

	// Set callback to run when API is loaded
	google.setOnLoadCallback(doMain);

	$(document).ready(function() {
		doMain();
		getExpSiteList(1);
		setKeyEvent();
	});
	
	function setKeyEvent(){
		$("#search_query").keydown(function(event) {
		   if(event.keyCode == 13) getExpSiteList(1);
		});
	}
	


	// Called when the Visualization API is loaded.
	function drawVisualization(expList) {

		// Create and populate a data table.
		timelineData = new google.visualization.DataTable();
		timelineData.addColumn('datetime', 'start');
		timelineData.addColumn('string', 'content');

		timelineData.addRows(expList);

		// specify options
		options = {
			"width" : "98%",
			"height" : "160px",
			"style" : "box",
			"min" : new Date(1990, 1, 1),
			"max" : new Date(2020, 12, 31),
			"zoomable" : true,
			"scale" : links.Timeline.StepDate.SCALE.YEAR,
			"step" : 1,
			"locale" : "kr",
			"showNavigation" : false,
			"showButtonNew" : false,
			"editable" : false

		};

		// Instantiate our timeline object.
		timeline = new links.Timeline(document.getElementById('mytimeline'));

		// Draw our timeline with the created data and options
		timeline.draw(timelineData, options);
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
		});

		return data;
	}

	//답사정보들 불러와서 타임라인에 뿌리기
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
				});

				google.visualization.events.addListener(timeline, 'select',
						function() {
							var row = undefined;
							var sel = timeline.getSelection();
							if (sel.length) {
								if (sel[0].row != undefined) {
									row = sel[0].row;
									getSiteListByExp(idxs[row]);
								}
								if (row != undefined) {
				                    var content = timelineData.getValue(row, 1);
				                    document.getElementById("selected_exp").innerHTML = '<i class="icon-ok-circle"></i>　'+content;
				                    
				                    //document.getElementById("info").innerHTML += "event " + row + " selected<br>";

				                }
							}
						});

			},

			

			complete : function() {
			}

		});

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
			beforeSend : function() {
				srcSiteList = new Array();
			},
			success : function(json) {
				$.each(json.list, function(i, siteInfo) {
					srcSiteList[siteInfo.site_idx] = siteInfo;
					
					$('<tr/>', {
						'class' : 'cursorp',
						
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
					})).append($('<td/>', {
						style:'text-align:center;width:30px;',
						'class':'text-center',
						html:'<input class=\"css-checkbox\" id=\"'+siteInfo.site_idx+'_chk\" name=\"site_chk_list\" type=\"checkbox\" value=\"'+siteInfo.site_idx+'\" />'
						+'<label for=\"'+siteInfo.site_idx+'_chk\" name=\"site_chk_list_lbl\" class=\"css-label lite-green-check\" style=\"margin-left: 5px;\"></label>'
					})).appendTo('#list_body');
					$('#total_cnt').val(siteInfo.total_cnt);
				});
			},
			complete:function(){
				drawPaging(page);
				//disableEdit();
				//initForm();
				//$('#add_btn').addClass('shown');
				//$('#upd_btn').addClass('shown');
				//$('#del_btn').addClass('shown');
			}
		});
		
	}
	
	/*
	* 코스목록 조회 (답사idx를 갖고)
	*/
	function getSiteListByExp(idx){
		$('#exp_idx').val(idx);	//현재 선택한 답사 idx값 저장.
		
		$.ajax({ 
			url : "expInfoPath",
			type : 'GET',
			dataType : 'json',
			data : 'idx=' + idx,
			beforeSend : function() {
				siteCnt=1;
				siteList = new Array();
				$('#list_body_second').empty();	//리스트 초기화
			},
			success : function(json) {
				$.each(json.list, function(i, siteInfo) {
					siteList[siteCnt] = siteInfo;
					siteCnt++;
				});
			},
			complete:function(){				
				drawSiteListByExp();
				//disableEdit();
				//initForm();
				//$('#add_btn').addClass('shown');
				//$('#upd_btn').addClass('shown');
				//$('#del_btn').addClass('shown');
			}
		});
	}
	
	function drawSiteListByExp(){
		$('#list_body_second').empty();
		for(var i=1; i<siteCnt;i++){
			var siteInfo = siteList[i];
			siteList[i].seq = i;	//순서 정해줌
			siteList[i].exp_idx = $('#exp_idx').val();
			
			$('<tr/>', {
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
			})).append($('<td/>', {
				style:'width:60px;',
				html:'<i class=\"icon-circle-arrow-up cursorp mr5\" onclick=\"javascript:upSeq('+i+')\"></i>'
				+'<i class=\"icon-circle-arrow-down cursorp mr5\" onclick=\"javascript:downSeq('+i+')\"></i>'
				+'<i class=\"icon-remove cursorp\" onclick=\"javascript:removeSeq('+i+')\"></i>'
			})).appendTo('#list_body_second');
		}
		$('.arrow, [class^=arrow-]').bootstrapArrows(); //bootstrap-arrow 초기화
	}
	
	function upSeq(seq){
		if(seq>1){
			swapSeq(seq,seq-1);
			drawSiteListByExp();
		}
		
	}
	
	function downSeq(seq){
		
		if(seq<siteCnt-1){
			swapSeq(seq,seq+1);
			drawSiteListByExp();
		}
	}
	
	function removeSeq(seq){
		for(var i=seq; i<siteCnt-1;i++){
			siteList[i]=siteList[i+1];
		}
		//siteList[siteCnt-1]=null;
		siteCnt--;
		console.log('site count after removing'+siteCnt);
		drawSiteListByExp();
	}
	
	function swapSeq(x,y){
		var tmp = siteList[x];
		siteList[x] = siteList[y];
		siteList[y] = tmp;
	}
	
	function addSites(){
		$("input:checkbox[name=site_chk_list]:checked").each(function(){
			siteList[siteCnt++]=srcSiteList[this.value];
			this.checked = false;
		});
		drawSiteListByExp();
	}
	
	
	function drawPaging(page){
		current_page = page;
        var pg = $("#Pagination").paging({
    		obj_id:'paging',
        	current_page: page,
        	total_cnt : $('#total_cnt').val(),
    		rows_per_page:$('#rows_per_page').val(),
    		num_display_entries:8,
        	user_function: 'getExpSiteList',
        	first_show_always : false,
        	last_show_always : false
        	
        	
        });
	}
	
	function insExpSite(){
		if(siteCnt<2) return;
		if(!confirm('답새-코스 매핑정보를 저장하시겠습니까?')) return;
		
		var insCnt = 0;
		var cnt=0;
		delExpSite();	//이전 매핑정보 삭제
		
		for(var i=1; i<siteCnt;i++){
			var siteInfo = siteList[i];
			
			var params = "";
			params += "exp_idx="+siteInfo.exp_idx;
			params += "&site_idx="+siteInfo.site_idx;
			params += "&seq="+siteInfo.seq;
			params += "&_method=POST";
			params = encodeURI(params);
			console.log(siteCnt+'input params = '+params);
			
			$.ajax({
				url : "expSiteMapping",
				type : 'POST',
				dataType : 'json',
				data : params,
				async : true,
				success : function(json) {
					if(json.int>0){
						insCnt++;
						cnt++;
						//alert('입력되었습니다.');
					}else{
						//alert('입력과정에 문제가 발생했습니다.');
					};
				},
				complete:function(){		
					console.log('after input = '+insCnt);
					if(cnt == siteCnt-1){
						if(insCnt == siteCnt-1){
							alert('저장되었습니다.');
						}else{
							alert('저장과정에 문제가 발생했습니다.');
						}	
					}
					
				}
			});
		}
	}
	
	function delExpSite(){
		var params = "";
		params += "exp_idx="+$('#exp_idx').val();
		params += "&_method=DELETE";
		params = encodeURI(params);
		//console.log('delete params = '+params);return;
		
		$.ajax({ 
			url : "expSiteMapping",
			type : 'POST',
			dataType : 'json',
			data : params,
			async : true,
			success : function(json) {
				if(json.int>0){
					//alert('입력되었습니다.');
				}else{
					//alert('입력과정에 문제가 발생했습니다.');
				};
			},
		});
	}
</script>