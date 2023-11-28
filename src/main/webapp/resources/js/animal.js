/**
 * 유기동물 관련 함수
 */
 

//유기동물목록 조회
function animal_list( pageNo ){
	$(".animal-top #upkind").removeClass("d-none")
	$(".pagination").closest("nav").remove();
	if( $("#sido").length==0 ) animal_sido();	
	
	var animal = { pageNo: pageNo, rows: page.pageList };
	animal.sido =  $("#sido").length>0 ? $("#sido").val() : "";
	animal.sigungu = $("#sigungu").length>0 ? $("#sigungu").val() : "";
	animal.shelter = $("#shelter").length>0 ? $("#shelter").val() : "";
	animal.upkind = $("#upkind").length>0 ? $("#upkind").val() : "";
	animal.kind = $("#kind").length>0 ? $("#kind").val() : "";
	
	$.ajax({
		url: "animal/list",
		//data: { pageNo: pageNo, rows: page.pageList }
		data: JSON.stringify( animal ),
		type: "post",
		contentType: "application/json"
	}).done(function(response){
		//response = response.response.body;
		$("#data-list").html( response )
	})
}

//시도 조회
function animal_sido(){
	$.ajax({
		url: 'animal/sido'
	}).done(function( response ){
		$(".animal-top").prepend( response )
	})
}

//축종변경
$("#upkind").change(function(){
	animal_kind(); //축종별 품종조회
	animal_list(1)
})

function animal_kind(){
	$("#kind").remove();
	
	$.ajax({
		url: "animal/kind",
		data: { upkind: $("#upkind").val() }	
	}).done( function( response ){
		$("#upkind").after( response )
	})
}

$(document)
.on( "click", ".popfile img", function(){
	if( $("#modal-image").length==1 ){
		$("#modal-image .modal-body").html( $(this).clone() );
		$("#modal-image .modal-body img").removeAttr("style")
		new bootstrap.Modal( $("#modal-image") ).show()
	}
})
 