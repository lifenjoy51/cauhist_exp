<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.net.URL"%>

<%@ taglib prefix="mvc" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<mvc:layout>
	<div class="page-header">
		<h3>원고관리</h3>
	</div>
	<div class="row">

		<!-- 코스정보 -->
		<div class="span5">
			<!-- 코스 검색폼 -->
			<form class="margin text-right" id="heritage_info_search_form">
				<div class="controls input-append text-right">
					<select class="spanb mr10" id="search_type" name="search_type">
						<option value='name'>이름</option>
						<option value='type'>유형</option>
					</select> <input class="span2" type="text" id="search_query"
						name="search_query" value="">
					<button class="btn" id="srch_btn" type="button"
						onclick="javascript:getHeritageInfoList(1);">
						<b>검색</b>
					</button>

					<input type="hidden" id="total_cnt" name="total_cnt" value="1" />
					<input type="hidden" id="current_page" name="current_page" value="" />
					<input type="hidden" id="rows_per_page" name="rows_per_page"
						value="8" /> <input type="text" style="display: none;" />
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
							<th>문화유산</th>
						</tr>
					</thead>
					<tbody id="list_body">
					</tbody>
				</table>
			</div>
			<div class="row center">
				<div id="Pagination" class="pagination"></div>
			</div>
			<div class="page-header">
			</div>
			<div class="row">
				<table class="table table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th>순번</th>
							<th>유형</th>
							<th>제목</th>
						</tr>
					</thead>
					<tbody id="list_body_second">
					</tbody>
				</table>
			</div>
		</div>

		<!-- 원고정보 -->
		<div class="span6 offset1">
			<form class="form-horizontal mt10 row margin" id="text_info_form">
				<div class="row">
					<div class="control-group error">
						<label class="control-label" for="heritage_name">문화유산</label>
						<div class="controls">
							<input class="span5 required" type="text" id="heritage_name"
								name="heritage_name"  readonly="readonly">

						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="text_name">원고제목</label>
						<div class="controls">
							<input class="span5 required" type="text" id="text_name"
								name="text_name" placeholder="ex) 병산서원 만대루" readonly="readonly">

						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="text_content">내용</label>
						<div class="controls">
							<textarea class="span5 required"id="text_content"
								name="text_content" readonly="readonly" rows="20"></textarea>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="author">저자</label>
						<div class="controls">
							<input class="span5" type="text" id="author"
								name="author" placeholder="ex) 08 홍길동" readonly="readonly">

						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="source">출처</label>
						<div class="controls">
							<textarea class="span5" id="source"
								name="source" placeholder="ex) 이순신, 『난중일기』, 1592" readonly="readonly"></textarea>

						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="text_type">유형</label>
						<div class="controls row-fluid">
							<div class="span3">
								<select class="spanb" id="text_type" name="text_type">
									<option value='1'>원고</option>
									<option value='2'>부록</option>
									<option value='3'>포스트잇</option>
								</select>
							</div>
							<div class="span6 text-right">
								<button class="btn btn-warning ml100" id="new_btn" type="button"
									onclick="javascript:newText();">
									<b>신규</b>
								</button>
								<button class="btn btn-success shown" id="add_btn" type="button"
									onclick="javascript:insText();">
									<b>등록</b>
								</button>
								<button class="btn btn-primary shown" id="upd_btn" type="button"
									onclick="javascript:updText();">
									<b>수정</b>
								</button>
								<button class="btn btn-danger shown" id="del_btn" type="button"
									onclick="javascript:delText();">
									<b>삭제</b>
								</button>
							</div>
						</div>
					</div>
					<input type="hidden" id="heritage_idx" name="heritage_idx" value="" />
					<input type="hidden" id="text_idx" name="text_idx" value="" />
					<input type="hidden" id="_method" name="_method" value="" />
				</div>
			</form>
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
	var textContents = new Array();
	var markerCnt = 0;

	$(document).ready(function() {
		getHeritageInfoList(1);
		setKeyEvent();
	});

	function setKeyEvent() {
		$("#search_query").keydown(function(event) {
			if (event.keyCode == 13)
				getHeritageInfoList(1);
		});
	}

	function enableEdit() {
		$('#text_name').removeAttr('readonly');
		$('#text_content').removeAttr('readonly');
		$('#author').removeAttr('readonly');
		$('#source').removeAttr('readonly');
	}

	function disableEdit() {
		$('#text_name').attr('readonly', 'true');
		$('#text_content').attr('readonly', 'true');
		$('#author').attr('readonly', 'true');
		$('#source').attr('readonly', 'true');
	}

	function drawPaging(page) {
		current_page = page;
		var pg = $("#Pagination").paging({
			obj_id : 'paging',
			current_page : page,
			total_cnt : $('#total_cnt').val(),
			rows_per_page : $('#rows_per_page').val(),
			num_display_entries : 8,
			user_function : 'getHeritageInfoList'
		});
	}

	function initForm() {
		$('#text_idx').val('');
		$('#text_name').val('');
		$("#text_type").val('');
	}

	/**
	 * 코스정보 신규
	 */
	function newText() {
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
		$('#del_btn').addClass('shown');
	}

	/**
	 * 코스정보 입력
	 */
	function insText() {
		if (!fnValidate())
			return; //검증
		if (!confirm('코스정보를 등록하시겠습니까?'))
			return;

		$("#_method").val('POST');
		/*
		var params = $("#text_info_form").clone() //입력시엔 idx삭제하고 파라미터 생성
		.find("#text_idx").remove().end().serialize();
		*/
		$("#text_idx").val(0);
		var params = $("#text_info_form").serialize();
		console.log(params);
		
		$.ajax({
			url : "textInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if (json.int > 0) {
					alert('입력되었습니다.');
					getTextList($('#heritage_idx').val());
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
	function updText() {
		if (!fnValidate())
			return; //검증
		if (!confirm('코스정보를 수정하시겠습니까?'))
			return;

		$("#_method").val('PUT');
		var params = $("#text_info_form").serialize();
		console.log(params);
		$.ajax({
			url : "textInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if (json.int > 0) {
					alert('수정되었습니다.');
					getTextList($('#heritage_idx').val());
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
	function delText() {
		if (!confirm('코스정보를 삭제하시겠습니까?'))
			return;

		$("#_method").val('DELETE');
		var params = $("#text_info_form").serialize();
		console.log('delete params -> ' + params);

		$.ajax({
			url : "textInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if (json.int > 0) {
					alert('삭제되었습니다.');
					getTextList($('#heritage_idx').val());
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
		$("#text_info_form").validate();
		return $("#text_info_form").valid();
	}

	/*
	 * 답사 상세정보 조회
	 */
	function getText(textIdx) {
		if (addMode) {
			if (!confirm('입력중인 내용이 사라집니다. 진행할까요?'))
				return;
		}

		//에러메세지 초기화
		$('label.error').addClass('shown');
		//상세정보읽기
		$('#text_idx').val(textIdx);
		$('#text_name').val($('#' + textIdx + '_name').text());
		$("#text_type").val($('#' + textIdx + '_type').attr('value'));
		$('#text_content').val(textContents[textIdx]);
		$("#author").val($('#' + textIdx + '_idx').attr('author'));
		$("#source").val($('#' + textIdx + '_idx').attr('source'));
		
		$('#add_btn').addClass('shown');
		$('#upd_btn').removeClass('shown');
		$('#del_btn').removeClass('shown');
		addMode = false;
		updMode = true;
		enableEdit();
	};

	/*
	 * 코스정보 목록 조회
	 */
	function getHeritageInfoList(page) {
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
			url : "heritageInfoList",
			type : 'GET',
			dataType : 'json',
			data : params,
			async : false,
			success : function(json) {
				$.each(json.list, function(i, heritageInfo) {
					$(
							'<tr/>',
							{
								'class' : 'cursorp',
								'onClick' : "javascript:getTextList("
										+ heritageInfo.heritage_idx + ");"
							}).append($('<td/>', {
						id : heritageInfo.heritage_idx + '_idx_heritage',
						html : heritageInfo.heritage_idx
					})).append($('<td/>', {
						id : heritageInfo.heritage_idx + '_type_heritage',
						value : heritageInfo.heritage_type,
						html : heritageInfo.heritage_type_name
					})).append($('<td/>', {
						id : heritageInfo.heritage_idx + '_name_heritage',
						html : heritageInfo.heritage_name
					})).appendTo('#list_body');
					$('#total_cnt').val(heritageInfo.total_cnt);
				});
			},
			complete : function() {
				drawPaging(page);
				disableEdit();
				initForm();
				$('#add_btn').addClass('shown');
				$('#upd_btn').addClass('shown');
				$('#del_btn').addClass('shown');
			}
		});

	}

	/*
	 * 원고 목록조회(답사코스idx)
	 */
	function getTextList(idx) {
		$('#heritage_idx').val(idx); //현재 선택한 답사 idx값 저장.
		$('#heritage_name').val($('#'+idx+'_name_heritage').text()); //현재 선택한 답사 idx값 저장.

		$.ajax({
			url : "textList",
			type : 'GET',
			dataType : 'json',
			data : 'heritage_idx=' + idx,
			beforeSend : function() {
				$('#list_body_second').empty(); //리스트 초기화
			},
			success : function(json) {
				$.each(json.list, function(i, textInfo) {
					$(
							'<tr/>',
							{
								'class' : 'cursorp',
								'onClick' : "javascript:getText("
										+ textInfo.text_idx + ");"
							}).append($('<td/>', {
						id : textInfo.text_idx + '_idx',
						html : textInfo.text_idx,
						author:textInfo.author,
						source:textInfo.source
						
					})).append($('<td/>', {
						id : textInfo.text_idx + '_type',
						value : textInfo.text_type,
						html : textInfo.text_type_name
					})).append($('<td/>', {
						id : textInfo.text_idx + '_name',
						html : textInfo.text_name
					})).appendTo('#list_body_second');
					textContents[textInfo.text_idx] = textInfo.text_content;
				});
			},
			complete : function() {
				disableEdit();
				initForm();
				$('#add_btn').addClass('shown');
				$('#upd_btn').addClass('shown');
				$('#del_btn').addClass('shown');
			}
		});
	}
</script>

<c:if test="${param.heritage_idx != null}">
<script>
	$(document).ready(function() {
		var p_heritage_idx = '${param.heritage_idx}';
		var p_heritage_name = '${param.heritage_name}';
		$('#search_query').val(p_heritage_name);
		getHeritageInfoList(1);
		getTextList(p_heritage_idx);
		
	});
</script>
</c:if>