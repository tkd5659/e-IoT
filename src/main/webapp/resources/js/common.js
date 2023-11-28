/**
 *  공통으로 사용될 함수선언
 */

//동적으로 모달창 구성하기
function modalAlert(  type, title, content ){
	$('#modal-alert .modal-title').html( title )
	$('#modal-alert .modal-body').html( content )
	
	//header의 아이콘 색상지정: <i class="fa-solid fa-circle-question"></i>
	$('.modal-icon')
		.removeClass( 'text-info text-warning text-danger '
					+ 'text-primary text-success '
					+ 'fa-circle-question fa-circle-exclamation')
		.addClass('text-'+type)
		
	$('#modal-alert .btn-ok')
		.removeClass('btn-info btn-warning btn-danger btn-primary btn-success');
	
	if( type=='danger' ){ //예/아니오 버튼
		$('#modal-alert .btn-danger').removeClass('d-none') //예 보이게
		$('#modal-alert .btn-ok').text('아니오')
		$('.modal-icon').addClass('fa-circle-question');
		
	}else{//확인버튼만
		$('#modal-alert .btn-danger').addClass('d-none') //예 안보이게
		$('#modal-alert .btn-ok').addClass('btn-'+type)
		$('.modal-icon').addClass('fa-circle-exclamation');
		
	}
	
}

//입력항목 입력여부 확인
function emptyCheck(){
	var ok = true;
	$('.check-empty').each(function(){
		if( $(this).val() == '' ){
			alert( $(this).attr("title") + " 입력하세요")
			$(this).focus()			
			ok = false;	
			return ok;		
		}
	})
	return ok;
}


//전화번호형태로 만들기
function toPhone( tag ){
	//02-1234-5678(10자리), 010-2345-8512(11자리)
	var phone = tag.val().replace( /[^0-9]/g, '' ).replace( /[-]/g, '' )
	if( phone.length >= 2 ){ //2자리이상: 02, 062, 010
		 var first = phone.substr(0,2) == "02" ? 2 : 3
		 	, second = first + 4
		 	, max = phone.substr(0,2)=="02" ? 10 : 11;
		
		if( phone.length > max ) phone = phone.substr(0, max);
		
		// 전화번호 중간중간 - 만들어 넣기
		if( phone.length > second ) {
			phone = phone.substr(0, first) + "-" + phone.substr(first, 4) + "-" + phone.substr(second,4)
		}else if( phone.length > first ){
			phone = phone.substr(0, first) + "-" + phone.substr(first, 4)
		}
	}
	tag.val( phone )
	
}

 
$( function() {
	
	//달력으로 날짜 선택
	if( $('.date').length > 0  ){ //요소의 존재여부판단: length
		var today = new Date();
		var range = today.getFullYear() - 100 + ":" + today.getFullYear(); //년도범위
		$.datepicker.setDefaults({
			dateFormat: 'yy-mm-dd',	//선택했을때 보여질 날짜형식
			changeMonth: true,		//월 선택 가능하게
			changeYear: true,		//년도 선택 가능하게
			showMonthAfterYear: true,	//년도>월 순서로 배치
			dayNamesMin: [ '일', '월', '화', '수', '목', '금', '토' ],
			monthNamesShort: [ '1월', '2월', '3월', '4월', '5월', '6월'
							 , '7월', '8월', '9월', '10월', '11월', '12월' ],
			maxDate: today,		//선택가능 최대날짜
			yearRange: range,  	//년도선택 범위
		})
	    $( ".date" ).datepicker();
	    $( ".date" ).attr('readonly', true); //입력불가
	}
	
	//다중파일 선택 첨부
	$('input#file-multiple').change(function(){
	 //var files = this.files;
	 var files = filterFile( this.files);
	for(i=0; i<files.length; i++){
		fileList.setFile( files[i] )
		}
		fileList.showFile()
	})
	
	
	//단일파일 선택 첨부
	$('input#file-single').change(function(){
		console.log( this.files )
		
		var attached = this.files[0];
		if( attached ){ //선택한 파일이 있다면
			console.log( attached.name )
			if( rejectedFile(attached, $(this)) ) return;
			
			singleFile = attached; //첨부된 파일정보 관리
			
			var _preview = $('#file-attach .file-preview')
			var _delete = $('#file-attach .file-delete')
			var _name = $('#file-attach .file-name')
			//선택한 파일명보이게
			if( _name.length>0 ) _name.text( attached.name )
			
			_delete.removeClass('d-none')
			
			//선택한 파일이 이미지인 경우만 처리
			if( isImage( attached.name ) ){
				//보여지게 할 태그가 있으면 선택한 이미지가 미리보여지게
				if( _preview.length > 0 ){
					_preview.html( "<img>" ) //동적으로 이미지태그 만들기
				}else{
					//이미지 미리보기 태그가 없는 경우: 삭제버튼 앞에 만들어넣기
					_delete.before( '<span class="file-preview"><img></span>' )
					_preview = $('#file-attach .file-preview')
				}
				//선택한 파일정보를 읽어서 이미지태그의 src로 지정
				var reader = new FileReader();
				reader.readAsDataURL( attached );
				reader.onload = function( e ){ //파일정보 읽기가 완료되면
					//_preview.children( 'img' ).attr('src', e.target.result );
					_preview.children( 'img' ).attr('src', this.result );
				}
				
			}else{
				_preview.empty();
				//이미지전용인 경우는 파일첨부 안되게 초기화
				if( $(this).hasClass('image-only') ){
					singleFile = '';
					_delete.addClass('d-none')
					$(this).val('')
				}
			}
		}		
	})
	
	
	//첨부파일 삭제
	$('#file-attach .file-delete').click(function(){
		//실제 첨부한 파일정보 없애기
		$('input[type=file]').val('')
		singleFile = ''
		
		//삭제버튼도 안나오게
		$(this).addClass('d-none')
		
		//미리보기 이미지 없애기
		var _preview = $('#file-attach .file-preview')		
		if( _preview.length>0 ) _preview.empty()
		
		//파일명 없애기
		var _name = $('#file-attach .file-name')		
		if( _name.length>0 ) _name.empty()
	})
	
	
/*	
	$('.file-drag')
	.on('dragover dragleave drop', function( e ){
		// 드롭을 허용하기 위해 기본 동작 취소
	    e.preventDefault();
	
		//드래그 오버시 form-control의 입력태그에 커서가 있을때처럼 보이게 스타일 적용
		if( e.type == 'dragover' )	$(this).addClass("drag-over");
		else						$(this).removeClass("drag-over");
	})
	.on('drop', function( e ){
		console.log( e.originalEvent.dataTransfer.files )
	})
*/
	$('.file-drag').on({
		'dragover dragleave drop' : function(e){
		    e.preventDefault();
			
			//드래그 오버시 form-control의 입력태그에 커서가 있을때처럼 보이게 스타일 적용
			if( e.type == 'dragover' )	$(this).addClass("drag-over");
			else						$(this).removeClass("drag-over");
		},
		'drop' : function(e){
			console.log('transfer> ', e.originalEvent.dataTransfer )
			var files = filterFile( filterFolder( e.originalEvent.dataTransfer) ) ;
			
			for( i=0; i<files.length; i++ ){
				fileList.setFile( files[i] );
			}
			console.log( fileList )
			fileList.showFile()
		}
	})

	
	$('body').on('dragover dragleave drop', function(e){
		 e.preventDefault();
	})
	

}); 

function filterFolder( transfer ){
	var files = [], folder = false;
	//console.log( 'items> ', transfer.items )
	for( i=0; i<transfer.items.length; i++ ){
		var entry = transfer.items[i].webkitGetAsEntry()
		//console.log( 'entry> ', entry)	
		if( entry.isFile ) files.push( transfer.files[i] )
		else               folder = true; 
	}
	if( folder ){
		alert("폴더는 첨부할 수 없습니다")
	}
	return files;
}


//다중파일정보를 file태그에 담기
function multipleFileUpload(){
	var transfer = new DataTransfer();
	var files = fileList.getFile();
	if (files.length > 0){
		for( i=0; i<files.length; i++){
			//업로드 해야 하는 파일만 추가
			if( fileList.info.upload[i] )  transfer.items.add( files[i] )
		}
	} 
	$('input#file-multiple').prop ( 'files', transfer.files)
	//console.log('multiple>', $('input#file-multiple').val() )
}
		
	



//파일선택시 취소한 경우 이전 선택한 파일로 처리
//첨부파일객체 정보를 file태그에 담기
function singleFileUpload(){
	if( singleFile != '' ){
		var transfer = new DataTransfer();
		transfer.items.add( singleFile );
		$('input[type=file]').prop( 'files', transfer.files )
		console.log( 'transfer> ', $('input[type=file]').val() )
	}
}

//첨부파일 크기 제한
function rejectedFile( fileInfo, tag ){
	//1K=1024byte, 1M=1024*1024 byte, 1G=1024*1024*1024 byte
	if( fileInfo.size >= 10 * 1024*1024){ //10M까지만 첨부가능
		alert("10Mb 이상의 파일은 첨부할 수 없습니다")
		tag.val('')
		return true		
	}else
		return false
}
//10Mb이상의 파일에 대한 alert 한번만 처리
function filterFile( files ){
	var overSize = false, sameFile = false;
	
	files = Object.values( files ).filter ( function(file){
		//10M 이상의 파일은 걸러내고 10M미만의 파일만 반환
		if( file.size >= 1024*1024*10 ){
			overSize = true;
		}
		
		//동일한 파일은 중복첨부하지 않고 
		var same = fileList.getFile().findIndex(function( f ){
			return f.name == file.name
		})
		if( same > -1 ) sameFile = true;
		
		return file.size < 1024*1024*10 && same == -1;
	})
	//console.log('2> ', files)
	
	if( overSize ) {
		alert("10Mb 이상 파일은 첨부할 수 없습니다. ")
	}
	if( sameFile ) {
		alert("이미 첨부한 파일을 중복첨부하지 않습니다. ")
	}
	
	return files;
	
}


//실제파일정보 담기:  url -> File객체로 만들기
function urlToFile( url, filename ){
	console.log( 'url', url)
	var file;
	$.ajax({
		//url: url,
		url: 'convertFile',
		data: { file: url },
		responseType: 'blob',
		async: false,  /* 기본은 비동기식처리임 -> 동기식*/
	}).done(function( response ){
		var blob = new Blob( [response] )
		file = new File( [blob], filename )
	})
	return file
}


//파일관리
//새로 추가한 파일은 업로드O
//이미 업로드되어 있는 파일을 삭제시 DB+물리적파일 삭제
function FileList(){
	this.files = [];
	this.info = { upload:[], fileId:[], removeId:[] }
	/* 업로드여부, 업로드되어있는 파일id, 삭제할 파일id*/
	
	this.setFile = function( file, id ){
		this.files.push( file );
		//id 가 없으면 새로 추가한 것이므로 업로드해야함
		this.info.upload.push( typeof id == "undefined" ? true : false )		
		if(  typeof id != "undefined" ) this.info.fileId.push( id )
	}
	
	this.getFile = function(){
		return this.files;
	}
	
	this.removeFile = function( idx ){  // [  'a', 'b', 'c', 'd' ]
	console.log( 'removeFile> ', idx)
		this.files.splice( idx, 1 )		//파일삭제
		this.info.upload.splice( idx, 1 ) //업로드여부삭제
		//이미 업로드되어 있는 파일을 삭제하면 삭제대상에 담기
		console.log( idx, ':', typeof this.info.fileId[idx] )
		if( typeof this.info.fileId[idx] != "undefined" ){
			this.info.removeId.push( this.info.fileId[idx] )
			this.info.fileId.splice( idx, 1 )
		}
	}
	
	this.showFile = function(){
		console.log('files>', this.files )
		console.log('info>', this.info )
		var tag = "";
		//파일목록에 파일이 있는 경우
		if( this.files.length > 0 ){ //backtick: ``
		for( i=0; i<this.files.length; i++){
			tag += `<div class="d-flex gap-3 align-items-center file-item my-1" >
						<button type='button' class='btn-close small' data-seq="${i}" ></button>
					<span class="file-name"> ${this.files[i].name} </span>
					
				   </div>`;
			}
		}else{
			tag = '<div class="py-3 text-center">첨부할 파일을 마우스로 끌어 오세요</div>';
		}
		$('.file-drag').html( tag )
	}
}
//동적으로 만들어진 태그에 대한 이벤트처리
$(document)
.on( 'click', '.file-item .btn-close', function(){
	//드래그드랍 첨부파일 삭제
	console.log( '삭제X' )
	fileList.removeFile ( $(this).data('seq') )
	fileList.showFile()
})
.on( "click", ".file-preview img", function(){
	if( $('#modal-image').length==1 ){ //이미지띄울 모달이 있으면
		$('#modal-image .modal-body').html( $(this).clone() )
		new bootstrap.Modal(  $('#modal-image') ).show()	
	}
})


		

//선택한 파일의 이미지 여부 확인
function isImage( filename ){
	var ext = filename.substr( filename.lastIndexOf('.')+1 ).toLowerCase();
	var imgs = [ 'jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp' ];
	return imgs.indexOf( ext )== -1 ? false : true;
}


