<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.net.URL"%>

<%@ taglib prefix="mvc" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<mvc:layout>
	<div class="container">
		<div class="row">
			<div class="page-header">
			<h1>답사정보입력</h1>
			</div>
			<div class="span8">
				<table class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th>순번</th>
							<th>답사이름</th>
							<th>답사유형</th>
							<th>시작일</th>
							<th>종료일</th>
							<th>메모</th>
						</tr>
					</thead>
					<tbody id="list_body">
					</tbody>
				</table>
				<div class="center">
					<div id="Pagination" class="pagination"></div>
                </div>
			</div>
			<div class="span4">
				<form class="form-horizontal mt10" id="exp_info_form">
				<fieldset>
					<div class="control-group error">
						<label class="control-label" for="exp_name">답사이름</label>
						<div class="controls">
							<input class="span2 required" type="text" id="exp_name" name="exp_name" placeholder="ex) 08 추계답사" readonly="readonly">
							
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="exp_type">유형</label>
						<div class="controls">
							<select class="spana" id="exp_type" name="exp_type">
							  <option value='1'>정기답사</option>
							  <option value='2'>기획답사</option>
							  <option value='3'>일일답사</option>
							</select>
						</div>
					</div>
					<div class="control-group error">
						<label class="control-label" for="">시작</label>
						<div class="controls">
							  <div class="input-prepend date" id="startDate" data-date="2001-01-01" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
								<span class="add-on"><i class="icon-calendar"></i></span>
								<input class="span1a required" id="start_date" name="start_date" size="16" type="text" value="" readonly="readonly">
							</div>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="">종료</label>
						<div class="controls">
							  <div class="input-prepend date" id="endDate" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
								<span class="add-on"><i class="icon-calendar"></i></span>
								<input class="span1a" id="end_date" name="end_date" size="16" type="text" value="" readonly="readonly">
							  </div>		
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="exp_memo">메모</label>
						<div class="controls">
							<input type="text" class="span3a" id="exp_memo" name="exp_memo" placeholder="ex) 충남 공주,부여일대" readonly="readonly">
						</div>
					</div>
					<div class="control-group">
					    <div class="controls text-right mr30">
						  <button class="btn btn-warning" id="new_btn" type="button" onclick="javascript:newExpInfo();"><b>신규</b></button>
					      <button class="btn btn-success shown" id="add_btn" type="button" onclick="javascript:insExpInfo();"><b>등록</b></button>
					      <button class="btn btn-primary shown" id="upd_btn" type="button" onclick="javascript:updExpInfo();"><b>수정</b></button>
					      <button class="btn btn-danger shown" id="del_btn" type="button" onclick="javascript:delExpInfo();"><b>삭제</b></button>
					    </div>
					  </div>
					  <input type="hidden" id="exp_idx" name="exp_idx" value=""/>
					  <input type="hidden" id="_method" name="_method" value=""/>
					  <input type="hidden" id="total_cnt" name="total_cnt" value="1"/>
					  <input type="hidden" id="current_page" name="current_page" value=""/>
					  <input type="hidden" id="rows_per_page" name="rows_per_page" value="10"/>
					  </fieldset> 
				</form>

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
	var addMode=false;
	var updMode=false;
	var current_page=1;
	
	$(document).ready(function() {
		initDatePicker();
		getExpInfoList(1);
	});
	
	function enableEdit(){
		$('#exp_name').removeAttr('readonly');
		$('#start_date').removeAttr('readonly');
		$('#end_date').removeAttr('readonly');
		$('#exp_memo').removeAttr('readonly');
	}
	
	function disableEdit(){
		$('#exp_name').attr('readonly','true');
		$('#start_date').attr('readonly','true');
		$('#end_date').attr('readonly','true');
		$('#exp_memo').attr('readonly','true');
	}
	
	function drawPaging(page){
		current_page = page;
        var pg = $("#Pagination").paging({
    		obj_id:'paging',
        	current_page: page,
        	total_cnt : $('#total_cnt').val(),
    		rows_per_page:10,
    		num_display_entries:15,
        	user_function: 'getExpInfoList'
        });
	}
	
	function initDatePicker(){
		$('#startDate').datepicker();
		$('#endDate').datepicker();
	}
	
	function initForm(){
		$('#exp_idx').val('');
		$('#exp_name').val('');
		$("#exp_type").val('');		
		$('#startDate').datepicker('setValue', '');
		$('#endDate').datepicker('setValue', '');
		$('#exp_memo').val('');
	}
	
	/**
	 * 답사정보 신규
	 */
	function newExpInfo(){
		if(addMode){
			if(!confirm('입력하던 내용을 버리고 새로 입력하시겠습니까?')) return;
			initForm();	//입력폼 초기화
			return;	//신규모드에서 신규모드로 다시 들어가는 것으로 이후 작업은 중복됨.
		}
		if(!confirm('새로운 답사정보를 입력하시겠습니까?')) return;
		addMode = true;	//입력모드 시작
		updMode = false;
		enableEdit();
		initForm();	//입력폼 초기화
		$('#add_btn').removeClass('shown');
		$('#upd_btn').addClass('shown');
		$('#del_btn').addClass('shown');
	}

	/**
	 * 답사정보 입력
	 */
	function insExpInfo() {
		if(!fnValidate()) return; //검증
		if(!confirm('답사정보를 등록하시겠습니까?')) return;
		
		$("#_method").val('POST');
		var params = $("#exp_info_form").clone()	//입력시엔 idx삭제하고 파라미터 생성
        .find("#exp_idx").remove()
        .end().serialize();
		
		$.ajax({ 
			url : "expInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if(json.int>0){
					alert('입력되었습니다.');
					getExpInfoList(current_page);
					addMode=false;
				}else{
					alert('입력과정에 문제가 발생했습니다.');
				};
			},
		});
	}

	/**
	 * 답사정보 수정
	 */
	function updExpInfo() {
		if(!fnValidate()) return; //검증
		if(!confirm('답사정보를 수정하시겠습니까?')) return;
		
		$("#_method").val('PUT');
		var params = $("#exp_info_form").serialize();
		
		$.ajax({ 
			url : "expInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if(json.int>0){
					alert('수정되었습니다.');
					getExpInfoList(current_page);
					updMode = false;					
				}else{
					alert('수정과정에 문제가 발생했습니다.');
				};
			},
		});
	}

	/**
	 * 답사정보 삭제
	 */
	function delExpInfo() {
		if(!confirm('답사정보를 삭제하시겠습니까?')) return;
		
		$("#_method").val('DELETE');
		var params = $("#exp_info_form").serialize();
		console.log('delete params -> '+params);
		
		$.ajax({ 
			url : "expInfo",
			type : 'POST',
			dataType : 'json',
			data : params,
			success : function(json) {
				if(json.int>0){
					alert('삭제되었습니다.');
					getExpInfoList(current_page);
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
		$("#exp_info_form").validate();
		return $("#exp_info_form").valid();		
	}
	
	/*
	* 답사 상세정보 조회
	*/
	function getExpInfo(expIdx){
		if(addMode){
			if(!confirm('입력중인 내용이 사라집니다. 진행할까요?')) return;
		}
		
		//에러메세지 초기화
		$('label.error').addClass('shown');
		//상세정보읽기
		$('#exp_idx').val(expIdx);
		$('#exp_name').val($('#'+expIdx+'_name').text());
		$("#exp_type").val($('#'+expIdx+'_type').attr('value'));
		$('#startDate').datepicker('setValue', $('#'+expIdx+'_start').text());	
		$('#endDate').datepicker('setValue', $('#'+expIdx+'_end').text());
		$('#exp_memo').val($('#'+expIdx+'_memo').text());
		
		$('#add_btn').addClass('shown');
		$('#upd_btn').removeClass('shown');
		$('#del_btn').removeClass('shown');
		addMode = false;
		updMode = true;
		enableEdit();
	};
	
	/*
	* 답사정보 목록 조회
	*/
	function getExpInfoList(page){
		$('#list_body').empty();
		$('#current_page').val(page);
		var params = $("#exp_info_form").clone()
        .find('input[value=""]').remove()
        .end().serialize();
		
		$.ajax({ 
			url : "expInfoList",
			type : 'GET',
			dataType : 'json',
			data : params,
			async : false,
			success : function(json) {
				$.each(json.list, function(i, expInfo) {
					$('<tr/>', {
						'class' : 'cursorp',
						'onClick' : "javascript:getExpInfo("+expInfo.exp_idx+");"
					}).append($('<td/>', {
						id:expInfo.exp_idx+'_idx',
						html : expInfo.exp_idx
					})).append($('<td/>', {
						id:expInfo.exp_idx+'_name',
						html : expInfo.exp_name
					})).append($('<td/>', {
						id:expInfo.exp_idx+'_type',
						value:expInfo.exp_type,
						html : expInfo.exp_type_name
					})).append($('<td/>', {
						id:expInfo.exp_idx+'_start',
						html : expInfo.start_date
					})).append($('<td/>', {
						id:expInfo.exp_idx+'_end',
						html : expInfo.end_date
					})).append($('<td/>', {
						id:expInfo.exp_idx+'_memo',
						html : expInfo.exp_memo
					})).appendTo('#list_body');
					$('#total_cnt').val(expInfo.total_cnt);
				});
			},
			complete:function(){
				drawPaging(page);
				disableEdit();
				initForm();
				$('#add_btn').addClass('shown');
				$('#upd_btn').addClass('shown');
				$('#del_btn').addClass('shown');
			}
		});
		
	}
</script>