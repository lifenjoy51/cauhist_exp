
/*
 * fnGetTR - TR생성 clsNm 클래스이름
 */
function fnGetTR(clsNm) {
    var tr = document.createElement("tr");
    tr.className = clsNm;
    return tr;
}

/*
 * fnGetTR - TD생성, 데이터박음, 클래스이름지정 tr TR객체 val 데이터 clsNm 클래스이름
 */
function fnAddVal(tr, val, clsNm) {
    var td = document.createElement("td");
    if (val == null || val == "null")
	val = " ";
    td.innerText = val;
    td.className = clsNm;
    tr.appendChild(td);
    return tr;
}

/*
 * fnNoData - 조회데이타가없을경우 pGridId 해당 그리드아이디
 */
function fnNoData(pGridId) {
    var cnt = $("#" + pGridId + " td").length;
    var tr = fnGetTR(pGridId + "Data");
    tr.className = pGridId + "_data";
    tr = fnAddVal(tr, "데이터가없습니다.", "");
    $("#" + pGridId).append(tr);
    $("." + pGridId + "_data td").attr('colSpan', cnt);
}

/*
 * fnInitGrid - 그리드초기화 pGridId 해당 그리드아이디
 */
function fnInitGrid(pGridId) {
    try {
	// 이전정보삭제 - 클래스이름으로 구분해 삭제함
	$('.' + pGridId + '_data').remove();

	// 페이징영역초기화
	$("#" + pGridId + "_paging").empty();
    } catch (e) {
    }

    return pGridId
}

/*
 * fnSetChkParam - chkeckbox형태의 파라미터 생성 pInName 값을생성할 대상 chkeckbox이름 pOutName 실제
 * 넘어갈 파라미터 이름
 */
function fnSetChkParam(pInName, pOutName) {
    var result = "";
    $("input[name='" + pInName + "']:checkbox:checked").each( function(i) {
	if (i != 0)
	    result += ",";
	result += $(this).val();
    });
    $("#" + pOutName).attr("value", result);
    
    return result;
}

/*
 * fnGetParam - 파라미터생성(HashMap) pFrmId 값을 넘길 input객체가 있는 Form ID
 */
function fnGetParam(pFrmId) {
    // input객체의 값을 담음
    var inputObjs = $("#" + pFrmId + " input");
    var str = "";
    for ( var i = 0; i < inputObjs.length; i++) {
	if (inputObjs.get(i).type == "text" || inputObjs.get(i).type == "hidden") {
	    if (i != 0)
		str += ",";
	    pName = inputObjs.get(i).name; // input name
	    pValue = inputObjs.get(i).value; // input value
	    inputObjs.get(i).value = trim(pValue); // trim
	    if (pName == "")
		pName = "dummy"; // input요소의 name속성이 없을경우 dummy로 강제지정
	    if (pValue == "")
		pValue = "";
	    str += pName + ":\'" + pValue + "\'";
	} else if (inputObjs.get(i).type == "checkbox") {
	    if (inputObjs.get(i).checked) {
		if (i != 0)
		    str += ",";
		pName = inputObjs.get(i).name; // input name
		pValue = inputObjs.get(i).value; // input value
		if (pName == "")
		    pName = "dummy"; // input요소의 name속성이 없을경우 dummy로 강제지정
		str += pName + ":\'" + pValue + "\'";
	    }
	} else if (inputObjs.get(i).type == "radio") {
	    if (inputObjs.get(i).checked) {
		if (i != 0)
		    str += ",";
		pName = inputObjs.get(i).name; // input name
		pValue = inputObjs.get(i).value; // input value
		if (pName == "")
		    pName = "dummy"; // input요소의 name속성이 없을경우 dummy로 강제지정
		str += pName + ":\'" + pValue + "\'";
	    }
	}

    };

    // select객체의 값을 담음
    var selectObjs = $("#" + pFrmId + " select");
    for (i = 0; i < selectObjs.length; i++) {
	if (inputObjs.length != 0)
	    str += ",";
	pName = selectObjs.get(i).name; // select name
	pValue = selectObjs.get(i).value; // select value
	if (pName == "")
	    pName = "dummy"; // select요소의 name속성이 없을경우 dummy로 강제지정
	str += pName + ":\'" + pValue + "\'";
    };
    
    // textarea객체의 값을 담음
    var textObjs = $("#" + pFrmId + " textarea");
    for (i = 0; i < textObjs.length; i++) {
	if (inputObjs.length != 0)
	    str += ",";
	pName = textObjs.get(i).name; // textarea name
	pValue = textObjs.get(i).value; // textarea value
	pValue = pValue.replace(/\r\n/g,'#'); ;
	if (pName == "")
	    pName = "dummy"; // textarea요소의 name속성이 없을경우 dummy로 강제지정
	str += pName + ":\'" + pValue + "\'";
    };
    // map생성
    eval("var param = {" + str + "};");
    return param;
}

function fnGetRexParam(pFrmId) {
    // input객체의 값을 담음
    var inputObjs = $("#" + pFrmId + " input");
    var str = "";
    for ( var i = 0; i < inputObjs.length; i++) {
	// if(i==0) str += '?';

	if (inputObjs.get(i).type == "text" || inputObjs.get(i).type == "hidden") {
	    if (i != 0)
		str += '&';
	    pName = inputObjs.get(i).name; // input name
	    pValue = inputObjs.get(i).value; // input value
	    inputObjs.get(i).value = trim(pValue); // trim
	    if (pName == "")
		pName = "dummy"; // input요소의 name속성이 없을경우 dummy로 강제지정
	    if (pValue == "")
		pValue = "";
	    str += pName + "=" + pValue + "";
	} else if (inputObjs.get(i).type == "checkbox") {
	    if (inputObjs.get(i).checked) {
		if (i != 0)
		    str += '&';
		pName = inputObjs.get(i).name; // input name
		pValue = inputObjs.get(i).value; // input value
		if (pName == "")
		    pName = "dummy"; // input요소의 name속성이 없을경우 dummy로 강제지정
		str += pName + "=" + pValue + "";
	    }
	} else if (inputObjs.get(i).type == "radio") {
	    if (inputObjs.get(i).checked) {
		if (i != 0)
		    str += '&';
		pName = inputObjs.get(i).name; // input name
		pValue = inputObjs.get(i).value; // input value
		if (pName == "")
		    pName = "dummy"; // input요소의 name속성이 없을경우 dummy로 강제지정
		str += pName + "=" + pValue + "";
	    }
	}

    }
    ;

    // select객체의 값을 담음
    var selectObjs = $("#" + pFrmId + " select");
    for ( var i = 0; i < selectObjs.length; i++) {
	if (inputObjs.length != 0)
	    str += "&";
	pName = selectObjs.get(i).name; // select name
	pValue = selectObjs.get(i).value; // select value
	if (pName == "")
	    pName = "dummy"; // select요소의 name속성이 없을경우 dummy로 강제지정
	str += pName + "=" + pValue + "";

	pOpName = selectObjs.get(i).name + "_option";
	pOpValue = selectObjs.get(i).options[selectObjs.get(i).selectedIndex].text;

	str += "&" + pOpName + "=" + pOpValue + "";

    }
    ;

    // 임시데이타
    str += "&first_input_id" + "=" + "" + "";
    str += "&last_modify_id" + "=" + "" + "";

    return str;
}

/*
 * fnModTD - TD속성변경 trObj 변경할TD요소가 속해있는 TR요소 fnName TD요소를 매개변수로갖는
 * 사용자함수(left,right,center일경우 align변경)
 */
function fnModTD(trObj, fnName) {
    var tdObj = trObj.lastChild;
    if (fnName == "left") {
	tdObj.align = "left";
    } else if (fnName == "right") {
	tdObj.align = "right";
    } else if (fnName == "center") {
	tdObj.align = "center";
    } else {
	eval("tdObj = " + fnName + "(tdObj);");
    }
    return trObj;
}

/*
 * fnModTD - TD속성변경 trObj 변경할TD요소가 속해있는 TR요소 fnName TD요소를 매개변수로갖는
 * 사용자함수(left,right,center일경우 align변경)
 */
function fnTdWidth(trObj, pWidth) {
    trObj.lastChild.style.width = pWidth;
    return trObj;
}

/*
 * fnDrawPaging - 페이징출력 pTotalPage 조회내역의 총 조회건수 pGridId 조회내역의 그리드아이디 pSrchFn
 * 조회함수명. 파라미터는 현재페이지.
 */
function fnDrawPaging(pTotalPage, pGridId, pSrchFn) {
    pCurPage = $("#" + pGridId + "_curpage").val();
    pPageRow = $("#" + pGridId + "_page_row").val();
    if (pPageRow == "" || pPageRow == 0) {
	pPageRow = 10; // 기본값 10
    }
    var pageCnt = Math.ceil(pTotalPage / pPageRow);
    if (pCurPage > pageCnt) {
	pCurPage = pageCnt;
    }

    // 페이징영역초기화
    $("#" + pGridId + "_paging").empty();

    // 맨처음페이지로
    fnGenPagingSpan("<<", 1, pGridId, pSrchFn);

    // 이전페이지로
    fnGenPagingSpan("<", ((+Math.floor((pCurPage - 1) / 10) * 10)), pGridId, pSrchFn);

    for ( var page = (+Math.floor((pCurPage - 1) / 10) * 10) + 1; page <= pageCnt; page++) {
	var span = document.createElement("span");
	if (pCurPage == page)
	    span.style.fontWeight = "bold";
	span.innerText = page;
	span.style.cursor = "pointer";
	span.onmouseover = function() {
	    this.style.backgroundColor = '#DEEBFA'
	};
	span.onmouseout = function() {
	    this.style.backgroundColor = '#FFFFFF'
	};
	span.onclick = new Function(pSrchFn + '(\'' + page + '\')');

	$("#" + pGridId + "_paging").append(" ");
	$("#" + pGridId + "_paging").append(span);
	$("#" + pGridId + "_paging").append(" ");

	if (page % 10 == 0)
	    break;
    }

    // 다음페이지로
    pPage = ((+Math.floor((pCurPage - 1) / 10) * 10) + 11);
    if (pPage > pageCnt)
	pPage = pageCnt;
    fnGenPagingSpan(">", pPage, pGridId, pSrchFn);

    // 맨끝으로
    fnGenPagingSpan(">>", pageCnt, pGridId, pSrchFn);
}

/*
 * fnGenPagingSpan
 */
function fnGenPagingSpan(pText, pPage, pGridId, pSrchFn) {
    var span = document.createElement("b");
    span.innerText = pText;
    span.style.cursor = "pointer";
    span.onmouseover = function() {
	this.style.backgroundColor = '#DEEBFA'
    };
    span.onmouseout = function() {
	this.style.backgroundColor = '#FFFFFF'
    };
    span.onclick = new Function(pSrchFn + '(\'' + pPage + '\')');
    $("#" + pGridId + "_paging").append(" ");
    $("#" + pGridId + "_paging").append(span);
    $("#" + pGridId + "_paging").append(" ");
}

/*
 * fnSetData - 데이터 세팅 (Radio제외) pMap 조회결과레코드 objNm 자료를 넣을 변수이름
 */
function fnSetData(pMap, objNm) {
    pData = "";
    try {
	if (pMap.length > 0) {
	    pData = eval("pMap[0]." + objNm.toUpperCase());
	    if (pData == "null" || pData == null)
		pData = "";
	    $("#" + objNm.toLowerCase() + "").attr("value", pData);
	}
    } catch (e) {
	window.status = e;
    }
    return pData;
}

/*
 * fnGetData - 값을 리턴함
 */
function fnGetData(pMap, objNm) {
    pData = "";
    try {
	if (pMap.length > 0) {
	    pData = eval("pMap[0]." + objNm.toUpperCase());
	    if (pData == "null" || pData == null)
		pData = "";
	}
    } catch (e) {
	window.status = e;
    }
    return pData;
}

/*
 * fnSetData - radio타입 데이터 세팅 pMap 조회결과레코드 objNm 자료를 넣을 변수이름
 */
function fnSetRadioData(pMap, objNm) {
    try {
	if (pMap.length > 0) {
	    pData = eval("pMap[0]." + objNm);
	    if (pData == "null" || pData == null)
		pData = " ";
	    $("input[name='" + objNm.toLowerCase() + "']:radio[value=" + pData + "]").attr("checked", "checked"); // radio처리
	}
    } catch (e) {
	window.status = e;
    }
    return pData;
}

/*
 * fnParamParser - 파라미터파싱 queryString 파라미터문자열 paramName 파라미터이름
 */
function fnParamParser(queryString, paramName) {
    var paramName = paramName + "=";
    if (queryString.length > 0) {
	begin = queryString.indexOf(paramName);

	if (begin != -1) {
	    begin += paramName.length;
	    end = queryString.indexOf("&", begin);
	    if (end == -1) {
		end = queryString.length
	    }
	    return unescape(queryString.substring(begin, end));
	}

	return "null";
    }
}

/*
 * fnKeepParam - 파라미터를 보관함 parameterString 파라미터문자열 formName 보관할 폼이름
 * paramNameArray 파라미터이름배열
 */
function fnKeepParam(parameterString, formName, paramNameArray) {
    var frmObj = document.createElement("form");
    frmObj.id = formName;
    frmObj.name = formName;

    var keepObj = document.createElement("input");
    keepObj.name = "isSrch";
    keepObj.type = "hidden";
    keepObj.value = "Y";
    frmObj.appendChild(keepObj);

    for ( var i = 0; i < paramNameArray.length; i++) {
	var keepObj = document.createElement("input");
	var paramName = paramNameArray[i];
	keepObj.name = paramName;
	keepObj.type = "hidden";
	keepObj.value = fnParamParser(parameterString, paramName);
	frmObj.appendChild(keepObj);
    }

    $("body").append(frmObj);
}

/*
 * fnSetParam - 들고온 파라미터의 값을 넣음 parameterString 파라미터문자열 paramNameArray 파라미터이름배열
 */
function fnSetParam(parameterString, paramNameArray) {
    if (paramNameArray == "")
	return;
    for ( var i = 0; i < paramNameArray.length; i++) {
	var paramName = paramNameArray[i];
	var keepObj = document.getElementById(paramName);
	var value = fnParamParser(parameterString, paramName);
	// alert("paramName:"+paramName+",keepObj:"+keepObj+",value:"+value);
	if (value != "" && value != null && value != "null") {
	    if (keepObj.type == "radio") {
		$("input[name=\"" + paramName + "\"]:radio[value=\"" + value + "\"]").attr("checked", "checked"); // radio처리
	    } else {
		keepObj.value = value;
	    }
	}
    }
}

/** **************** */
/*******************************************************************************
 * 팝업 함수들 /
 ******************************************************************************/

/*
 * fnVehicleSearchPopup - 차량검색팝업
 */
function fnVehicleSearchPopup() {
    var url = "/abs/vmsBaseInfo.do?cmd=popup";
    var popNm = "VehicleSearchPopup";
    var status = "toolbar=0,location=0,status=0,menubar=0,scrollbars=0,resizable=0,width=800,height=600";
    window.open(url, popNm, status);
}

/*
 * fnClothTypeSearchPopup - 피복종류검색팝업
 */
function fnClothTypeSearchPopup() {
    var url = "/abs/ccmClothType.do?cmd=popup";
    var popNm = "ClothTypeSearchPopup";
    var status = "toolbar=0,location=0,status=0,menubar=0,scrollbars=0,resizable=0,width=640,height=480";
    window.open(url, popNm, status);
}

/*
 * fnZipNoSearchPopup - 우편번호검색팝업
 */
function fnZipNoSearchPopup(pZipCode, pAddress) {
    var params = new Array();
    url = "/ZipCodePopup.do";
    params = window.showModalDialog(url, "", 'resizable:yes;scroll:yes;status:no;help:no;dialogHeight:480px;dialogWidth:460px');
    if (params != null) {
	$("#" + pZipCode).attr("value", params[0]);
	$("#" + pAddress).attr("value", params[1]);
    }
}

/** **************** */
/*******************************************************************************
 * 유틸성 함수들 /
 ******************************************************************************/

/*
 * 왼쪽에 위치한 whitespace 문자를 제거
 */
function ltrim(str) {
    return str.replace(/^\s+/, "");
}

/*
 * 오른쪽에 위치한 whitespace 문자를 제거
 */
function rtrim(str) {
    return str.replace(/\s+$/, "");
}

/*
 * 양쪽의 whitespace 문자를 제거
 */
function trim(str) {
    return rtrim(ltrim(str));
}

/*
 * 주어진 문자열의 왼쪽을 padding 문자로 채운다
 */
function lpad(str, n, padding) {
    if (str.length >= n)
	return str;
    else {
	var len = n - str.length;
	var pad_str = str;
	for ( var i = 0; i < len; i++)
	    pad_str = padding + pad_str;

	return pad_str;
    }
}

/*
 * 주어진 문자열의 오른쪽을 padding 문자로 채운다
 */
function rpad(str, n, padding) {
    if (str.length >= n)
	return str;
    else {
	var len = n - str.length;
	var pad_str = str;
	for ( var i = 0; i < len; i++)
	    pad_str = pad_str + padding;

	return pad_str;
    }
}

// add comma
function add_comma(value) {

    if (value == null || value == "null")
	value = " ";

    var src;
    var i;
    var factor;
    var su;
    var Spacesize = 0;

    var tmp = value.toString();
    
    var tmp0 = tmp.split(".");
    String_val = tmp0[0];
    
    factor = String_val.length % 3;
    su = (String_val.length - factor) / 3;
    src = String_val.substring(0, factor);

    for (i = 0; i < su; i++) {
	if ((factor == 0) && (i == 0))// " XXX "の場合
	{
	    src += String_val.substring(factor + (3 * i), factor + 3 + (3 * i));
	} else {
	    if (String_val.substring(factor + (3 * i) - 1, factor + (3 * i)) != "-")
		src += ",";
	    src += String_val.substring(factor + (3 * i), factor + 3 + (3 * i));
	}
    }
    if(tmp0[1]) src += "." + tmp0[1];
    return src;
}

// delete comma
function remove_comma(value) {

    if (value == null || value == "null")
	value = " ";

    var x, ch;
    var i = 0;
    var newVal = "";
    for (x = 0; x < value.length; x++) {
	ch = value.substring(x, x + 1);
	if (ch != ",")
	    newVal += ch;
    }
    return newVal;
}

/*
 * 정답확인시 특수기호 제거
 */
function fnRemoveSign(str) {
	var rtn=str;
    rtn = rtn.replace(/\'/gi, "");	//'
    rtn = rtn.replace(/\?/gi, "");	//?
    rtn = rtn.replace(/\./gi, "");	//.
    rtn = rtn.replace(/\!/gi, "");	//!
    
    return rtn;
}

/*
 * 정답확인시 공백제거
 */
function fnRemoveSpace(str) {
    return str.replace(/ /gi, "");
}

/*
 * 임의순서가져오기
 */
function randOrd() {
	return (Math.round(Math.random()) - 0.5);
}

/*
 * Textarea 글자수제한
 */
function limitCharacters(textid, limit) {
	// 잆력 값 저장
	var text = $('#' + textid).val();
	// 입력값 길이 저장
	var textlength = text.length;
	if (textlength > limit) {
		// 제한 글자 길이만큼 값 재 저장
		$('#' + textid).val(text.substr(0, limit));
		return false;
	}
}

/*
 * jQuery Ajax Error 처리
 */
$(function() {
    $.ajaxSetup({
        error: function(jqXHR, exception) {
            if (jqXHR.status === 0) {
                alert('Not connect.\n Verify Network.');
            } else if (jqXHR.status == 404) {
                alert('Requested page not found. [404]');
            } else if (jqXHR.status == 500) {
                alert('Internal Server Error [500].');
            } else if (exception === 'parsererror') {
                alert('Requested JSON parse failed.');
            } else if (exception === 'timeout') {
                alert('Time out error.');
            } else if (exception === 'abort') {
                alert('Ajax request aborted.');
            } else {
                alert('Uncaught Error.\n' + jqXHR.responseText);
            }
        }
    });
});

/*
*
*/
$.expr[':'].withvalidationError = function(obj){
  var $this = $(obj);
  return ($this.attr('class') == 'text-error');
};