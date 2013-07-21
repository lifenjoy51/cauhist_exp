<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.net.URL"%>

<%@ taglib prefix="mvc" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<mvc:layout>
	<div class="page-header">
		<h3>문화유산정보 등록</h3>
	</div>
	<div class="row">

		<!-- 코스정보 -->
		<div class="span5">
			<!-- 코스 검색폼 -->
			<form class="margin text-right" id="site_info_search_form">
				<div class="controls input-append text-right">
					<select class="spanb mr10" id="search_type" name="search_type">
						<option value='name'>답사장소</option>
						<option value='type'>유형</option>
						<option value='region'>지역</option>
					</select> <input class="span2" type="text" id="search_query"
						name="search_query" value="">
					<button class="btn" id="srch_btn" type="button"
						onclick="javascript:getHeritageList(1);">
						<b>검색</b>
					</button>

					<input type="hidden" id="total_cnt" name="total_cnt" value="1" />
					<input type="hidden" id="current_page" name="current_page" value="" />
					<input type="hidden" id="rows_per_page" name="rows_per_page"
						value="16" /> <input type="text" style="display: none;" />
				</div>
			</form>

			<!-- 코스정보 목록 -->
			<div class="row">
				<table
					class="table table-striped table-bordered table-hover table-condensed">
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

		<!-- 문화유산정보 -->
		<div class="span6 offset1">
			<form class="form-horizontal mt10 row margin" id="heritage_info_form">
				<div class="row">
					<div class="control-group error">
						<label class="control-label" for="site_name">답사장소</label>
						<div class="controls">
							<input class="span5 required" type="text" id="site_name"
								name="site_name"  readonly="readonly">

						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="heritage_name">문화유산</label>
						<div class="controls">
							<input class="span5 required" type="text" id="heritage_name"
								name="heritage_name" placeholder="ex) 병산서원 만대루" readonly="readonly">

						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="heritage_type">유형</label>
						<div class="controls row-fluid">
							<div class="span3">
							<select class="spanb" id="heritage_type" name="heritage_type">
								<option value='1'>기타</option>
								<option value='2'>사찰</option>
								<option value='3'>절터</option>
								<option value='4'>불상</option>
								<option value='5'>탑·부도</option>
								<option value='6'>당간·지주</option>
								<option value='7'>석물</option>
								<option value='8'>서원</option>
								<option value='9'>향교</option>
								<option value='10'>사우</option>
								<option value='11'>관아</option>
								<option value='12'>한옥·고택·종택</option>
								<option value='13'>누정(樓·亭·閣·軒·齋)</option>
								<option value='14'>성곽</option>
								<option value='15'>선사유적</option>
								<option value='16'>고분</option>
								<option value='17'>비석</option>
								<option value='18'>민간신앙</option>
								<option value='19'>전적지</option>
								<option value='20'>박물관·기념관</option>
								<option value='21'>학교</option>
								<option value='22'>마을</option>
								<option value='23'>사적지</option>
								<option value='24'>공원</option>
								<option value='25'>유적(일반)</option>
								<option value='26'>문헌</option>
								<option value='27'>고문서</option>
								<option value='28'>서화류</option>
								<option value='29'>유물(일반)</option>

							</select>
						</div>
						<div class="span6 text-right">
							<button class="btn btn-success shown" id="text_add_btn" type="button" onclick="javascript:addText();"><b>원고등록</b></button>
							<button class="btn btn-warning" id="new_btn" type="button"
								onclick="javascript:newHeritage();">
								<b>신규</b>
							</button>
							<button class="btn btn-success shown" id="add_btn" type="button"
								onclick="javascript:insHeritage();">
								<b>등록</b>
							</button>
							<button class="btn btn-primary shown" id="upd_btn" type="button"
								onclick="javascript:updHeritage();">
								<b>수정</b>
							</button>
							<button class="btn btn-danger shown" id="del_btn" type="button"
								onclick="javascript:delHeritage();">
								<b>삭제</b>
							</button>
						</div>
					</div>
					<input type="hidden" id="site_idx" name="site_idx" value="" />
					<input type="hidden" id="heritage_idx" name="heritage_idx" value="" />
					<input type="hidden" id="_method" name="_method" value="" />
				</div>
			</form>
			<div class="row">
				<table class="table table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th>순번</th>
							<th>유형</th>
							<th>문화유산</th>
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
	var addMode = false;
	var updMode = false;
	var current_page = 1;
	var addrArray = new Array();
	var markers = new Array();
	var infowindows = new Array();
	var markerCnt = 0;

	$(document).ready(function() {
		 
		getExpSiteList(1);
		setKeyEvent();
	});

	function setKeyEvent() {
		$("#search_query").keydown(function(event) {
			if (event.keyCode == 13)
				getExpSiteList(1);
		});
	}

	function enableEdit() {
		$('#heritage_name').removeAttr('readonly');
	}

	function disableEdit() {
		$('#heritage_name').attr('readonly', 'true');
	}

	function drawPaging(page) {
		current_page = page;
		var pg = $("#Pagination").paging({
			obj_id : 'paging',
			current_page : page,
			total_cnt : $('#total_cnt').val(),
			rows_per_page : $('#rows_per_page').val(),
			num_display_entries : 10,
			user_function : 'getExpSiteList'
		});
	}

	function initForm() {
		$('#heritage_idx').val('');
		$('#heritage_name').val('');
		$("#heritage_type").val('');
	}

	/**
	 * 코스정보 신규
	 */
	function newHeritage() {
		if (addMode) {
			if (!confirm('입력하던 내용을 버리고 새로 입력하시겠습니까?'))
				return;
			initForm(); //입력폼 초기화
			return; //신규모드에서 신규모드로 다시 들어가는 것으로 이후 작업은 중복됨.
		}
		if (!confirm('새로운 코스정보를 입력하시겠습니까?'))
			return;
		addMode = true; //입력모드 시작
		updMode = false;
		enableEdit();
		initForm(); //입력폼 초기화
		$('#add_btn').removeClass('shown');
		$('#upd_btn').addClass('shown');
		$('#text_add_btn').addClass('shown');
		$('#del_btn').addClass('shown');
	}

	/**
	 * 코스정보 입력
	 */
	function insHeritage() {
		if (!fnValidate())
			return; //검증
		if (!confirm('코스정보를 등록하시겠습니까?'))
			return;

		$("#_method").val('POST');
		var params = $("#heritage_info_form").clone() //입력시엔 idx삭제하고 파라미터 생성
		.find("#heritage_idx").remove().end().serialize();

		$.ajax({
			url : "heritageInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if (json.int > 0) {
					alert('입력되었습니다.');
					getHeritageList($('#site_idx').val());
					addMode = false;
				} else {
					alert('입력과정에 문제가 발생했습니다.');
				}
				;
			},
		});
	}

	/**
	 * 코스정보 수정
	 */
	function updHeritage() {
		if (!fnValidate())
			return; //검증
		if (!confirm('코스정보를 수정하시겠습니까?'))
			return;

		$("#_method").val('PUT');
		var params = $("#heritage_info_form").serialize();

		$.ajax({
			url : "heritageInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if (json.int > 0) {
					alert('수정되었습니다.');
					getHeritageList($('#site_idx').val());
					updMode = false;
				} else {
					alert('수정과정에 문제가 발생했습니다.');
				}
				;
			},
		});
	}

	/**
	 * 코스정보 삭제
	 */
	function delHeritage() {
		if (!confirm('코스정보를 삭제하시겠습니까?'))
			return;

		$("#_method").val('DELETE');
		var params = $("#heritage_info_form").serialize();
		console.log('delete params -> ' + params);

		$.ajax({
			url : "heritageInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if (json.int > 0) {
					alert('삭제되었습니다.');
					getHeritageList($('#site_idx').val());
					updMode = false;
				} else {
					alert('삭제과정에 문제가 발생했습니다.');
				}
				;
			},
		});
	}

	/*
	 * 입력폼 유효성 검증
	 */
	function fnValidate() {
		$("#heritage_info_form").validate();
		return $("#heritage_info_form").valid();
	}

	/*
	 * 답사 상세정보 조회
	 */
	function getHeritage(heritageIdx) {
		if (addMode) {
			if (!confirm('입력중인 내용이 사라집니다. 진행할까요?'))
				return;
		}

		//에러메세지 초기화
		$('label.error').addClass('shown');
		//상세정보읽기
		$('#heritage_idx').val(heritageIdx);
		$('#heritage_name').val($('#' + heritageIdx + '_name').text());
		$('#addr_search_query').val($('#' + heritageIdx + '_name').text()); //지도검색어에 자동등록

		$("#heritage_type").val($('#' + heritageIdx + '_type').attr('value'));

		$('#add_btn').addClass('shown');
		$('#upd_btn').removeClass('shown');
		$('#text_add_btn').removeClass('shown');		
		$('#del_btn').removeClass('shown');
		addMode = false;
		updMode = true;
		enableEdit();
	};

	/*
	 * 코스정보 목록 조회
	 */
	function getExpSiteList(page) {
		$('#list_body').empty();
		$('#current_page').val(page);
		var params = "";
		params += "total_cnt=" + $('#total_cnt').val();
		params += "&current_page=" + $('#current_page').val();
		params += "&rows_per_page=" + $('#rows_per_page').val();
		params += "&search_query=" + $('#search_query').val();
		params += "&search_type=" + $('select[name="search_type"]').val();
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
					$(
							'<tr/>',
							{
								'class' : 'cursorp',
								'onClick' : "javascript:getHeritageList("
										+ siteInfo.site_idx + ");"
							}).append($('<td/>', {
						id : siteInfo.site_idx + '_idx_site',
						html : siteInfo.site_idx
					})).append($('<td/>', {
						id : siteInfo.site_idx + '_type_site',
						value : siteInfo.site_type,
						html : siteInfo.site_type_name
					})).append($('<td/>', {
						id : siteInfo.site_idx + '_name_site',
						html : siteInfo.site_name
					})).append($('<td/>', {
						id : siteInfo.site_idx + '_region_site',
						addr : siteInfo.addr,
						latitude : parseFloat(siteInfo.latitude).toFixed(4),
						longitude : parseFloat(siteInfo.longitude).toFixed(3),
						region : siteInfo.region,
						city : siteInfo.city,
						html : siteInfo.region
					})).appendTo('#list_body');
					$('#total_cnt').val(siteInfo.total_cnt);
				});
			},
			complete : function() {
				drawPaging(page);
				disableEdit();
				initForm();
				$('#add_btn').addClass('shown');
				$('#upd_btn').addClass('shown');
				$('#text_add_btn').addClass('shown');				
				$('#del_btn').addClass('shown');
			}
		});

	}

	/*
	 * 문화유산 목록조회(답사코스idx)
	 */
	function getHeritageList(idx) {
		$('#site_idx').val(idx); //현재 선택한 답사 idx값 저장.
		$('#site_name').val($('#'+idx+'_name_site').text()); //현재 선택한 답사 idx값 저장.

		$.ajax({
			url : "heritageList",
			type : 'GET',
			dataType : 'json',
			data : 'site_idx=' + idx,
			beforeSend : function() {
				$('#list_body_second').empty(); //리스트 초기화
			},
			success : function(json) {
				$.each(json.list, function(i, heritageInfo) {
					$(
							'<tr/>',
							{
								'class' : 'cursorp',
								'onClick' : "javascript:getHeritage("
										+ heritageInfo.heritage_idx + ");"
							}).append($('<td/>', {
						id : heritageInfo.heritage_idx + '_idx',
						html : heritageInfo.heritage_idx
					})).append($('<td/>', {
						id : heritageInfo.heritage_idx + '_type',
						value : heritageInfo.heritage_type,
						html : heritageInfo.heritage_type_name
					})).append($('<td/>', {
						id : heritageInfo.heritage_idx + '_name',
						html : heritageInfo.heritage_name
					})).appendTo('#list_body_second');
				});
			},
			complete : function() {
				disableEdit();
				initForm();
				$('#add_btn').addClass('shown');
				$('#upd_btn').addClass('shown');
				$('#text_add_btn').addClass('shown');				
				$('#del_btn').addClass('shown');
			}
		});
	}
	
	function addText(){
		if(!confirm($('#heritage_name').val()+'에 대한 원고 입력 페이지로 이동하시겠습니까?'))return;
		location.href = "textInfo?heritage_idx="+$('#heritage_idx').val()+"&heritage_name="+$('#heritage_name').val();
	}
</script>
<c:if test="${param.site_idx != null}">
<script>
	$(document).ready(function() {
		var p_site_idx = '${param.site_idx}';
		var p_site_name = '${param.site_name}';
		$('#search_query').val(p_site_name);
		getExpSiteList(1);
		getHeritageList(p_site_idx);
		
	});
</script>
</c:if>