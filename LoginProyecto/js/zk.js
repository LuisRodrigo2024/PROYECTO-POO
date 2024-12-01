var zk = {
    fancyboxHistory: [],
    fancyboxIndex: -1,
    router: null,
    currentUrl: null,
    startRouter: function(){
        zk.router = new AppRouter;
        zk.router.on('route:mainRouteHandler', function(url, queryString) {
            if(url != null){
                zk.currentUrl = "/" + url ;
                if(queryString != null){
                    zk.currentUrl += '?'+ queryString;
                }
                $.ajax({
                    url: zk.currentUrl,
                    type: 'GET',
                    beforeSend: function(){
                        $.niftyAside("hide");
                        $.niftyNav('expand');
                        $('#page-content').niftyOverlay('show');
                    },
                    data: null,
                    dataType: 'html',
                    success: function(response){
                        $('#page-content').html(response);
                    },
                    complete: function(){
                        $('#page-content').niftyOverlay('hide');
                    },
                    error: function(){
                        $.niftyNoty({
                            type: 'danger',
                            container : 'page',
                            html : '\
                            <div class="media-left">\
                                <span class="icon-wrap icon-wrap-xs icon-circle alert-icon">\
                                    <i class="fa fa-bolt fa-lg"></i>\
                                </span>\
                            </div>\
                            <div class="media-body">\
                                <h4 class="alert-title">Error de carga</h4>\
                                <p class="alert-message">No se pudo realizar la operación.</p>\
                            </div>',
                            timer : 3000
                        });
                    }
                });
            }
        });

        Backbone.history.start();
    },
    reloadPage: function(){
        Backbone.history.loadUrl();
    },
    goToUrl: function(url){
        if(url == zk.currentUrl){
            return zk.reloadPage();
        }

        zk.router.navigate("/" + url);
    },
    printDocument: function (url, width, height) {
        if(!width) width = 800;
        if(!height) height = 600;
        window.open(url, '_blank', 'width='+ width +',height=' + height);
    },
    formErrors: function(form, errors){
        for(i in errors){
            $(form).data('bootstrapValidator').updateStatus(i, 'INVALID');
            $('[data-bv-for="'+ i +'"]', $(form)).html(errors[i][0]);
        }
        return false;
    },
    confirm: function(message, callback, callbackCancel){
        $.prompt(message, {
            submit: function(e, v){
                e.preventDefault();
                if(v){
                    if(callback) callback();
                }else{
                    if(callbackCancel) callbackCancel();
                }

                $.prompt.close();
            },
            buttons: {
                'Si': true,
                'No': false
            }
        });
    },
    sendData: function(url, data, callback, container){
        //_form = this;
        options = {
            url: url,
            type: 'POST',
            beforeSend: function(){
                if(!container)
                    $('#page-content').niftyOverlay('show');
                else
                    $(container).niftyOverlay('show');
            },
            
            data: data,
            dataType: 'json',
            success: function(r){
                if(callback) return callback(r);
            },
            complete: function(){
                if(!container)
                    $('#page-content').niftyOverlay('hide');
                else
                    $(container).niftyOverlay('hide');
              
            },
            error: function(){
                alert('No se pudo realizar la petición');
            }
        };
        if(data.toString() == '[object FormData]'){
            options['processData'] = false;
            options['contentType'] = false;
            options['dataType'] = 'json';
        }

        $.ajax(options);
    },
    searchForm: function(url, data, container, callback){
        _form = this;
        $.ajax({
            url: url,
            type: 'POST',
            beforeSend: function(){
                $(container).niftyOverlay('show');
            },
            
            data: data,
            
            
            success: function(r){
                $(container).html(r);
                if(callback){
                    callback(r);
                }
            },
            complete: function(){
               $(container).niftyOverlay('hide');
            },
            error: function(){
                alert('No se pudo realizar la petición');
            }
        });
    },
    pageAlert: function(options){
        options = $.extend({
            type: 'info',
            message: '',
            title: '',
            timer: 3000,
            icon: '',
            container: 'page'
        }, options);

        var html = '';
        if(options.icon != ''){
            html += '<div class="media-left">\
                <span class="icon-wrap icon-wrap-xs icon-circle alert-icon">\
                    <i class="fa fa-'+ options.icon +' fa-lg"></i>\
                </span>\
            </div>';
        }
        html += '<div class="media-body">';
        if(options.title != ''){
            html += '<h4 class="alert-title">'+ options.title +'</h4>';
        }
        html += '<p class="alert-message">'+ options.message +'</p>\
            </div>';

        $.niftyNoty({
            type: options.type,
            container : options.container,
            html : html,
            timer : options.timer
        });
    },
    filterCountryDPD: function(_data){
        _data = $.extend({
            pais: {
                field: '#pais_id'
            },
            departamento: {
                field: '#departamento_id',
                value: ''
            },
            provincia: {
                field: '#provincia_id',
                value: ''
            },
            distrito: {
                field: '#distrito_id',
                value: ''
            },
        }, _data);
        
        // PROVINCIA
        $(_data.provincia.field).bind('change', function(){
            $(_data.distrito.field).find('.item').remove();
            $.post('/info/get_distritos', {provincia_id: $(_data.provincia.field).val()}, function(r){
                for(i in r){
                    distrito = r[i];
                    $(_data.distrito.field).append('<option value="'+ distrito.id +'" class="item" '+ (distrito.id == _data.distrito.value ? 'selected' : '') +'>'+ distrito.nombre +'</option>');
                }
                $(_data.distrito.field).trigger('change');
            }, 'json');
        });
        // DEPARTAMENTO
        $(_data.departamento.field).bind('change', function(){
            $(_data.provincia.field).find('.item').remove();
            $.post('/info/get_provincias', {departamento_id: $(_data.departamento.field).val()}, function(r){
                for(i in r){
                    provincia = r[i];
                    $(_data.provincia.field).append('<option value="'+ provincia.id +'" class="item" '+ (provincia.id == _data.provincia.value ? 'selected' : '') +'>'+ provincia.nombre +'</option>');
                }
                $(_data.provincia.field).trigger('change');
            }, 'json');
        });
        // PAIS HANDLER
        $(_data.pais.field).bind('change', function(){
            $(_data.departamento.field).find('.item').remove();
            $.post('/info/get_departamentos', {pais_id: $(_data.pais.field).val()}, function(r){
                
                for(i in r){
                    departamento = r[i];
                    $(_data.departamento.field).append('<option value="'+ departamento.id +'" class="item" '+ (departamento.id == _data.departamento.value ? 'selected' : '') +'>'+ departamento.nombre +'</option>');
                }
                $(_data.departamento.field).trigger('change');
            }, 'json');
        });
        
        $(_data.pais.field).trigger('change');
    }
};

function fancyboxNoClose(url, addHistory){
    if(addHistory !== false){
        zk.fancyboxHistory.push(url);
        zk.fancyboxIndex = zk.fancyboxHistory.length - 1;
        //++zk.fancyboxIndex;
    }

    $.fancybox({
        href: url, 
        type: 'ajax', 
        enableEscapeButton: false,  
        hideOnOverlayClick: false, 
        overlayColor : '#FFF', 
        centerOnScroll: true, 
        scrolling: 'no',
        modal: true,
        //autoHeight : true,
        closeClick: false, 
        helpers: {
            overlay : {
                closeClick : false,
                background: '#fff'
            }
        }
    });
}

function fancybox(url, addHistory){
    if(addHistory !== false){
        zk.fancyboxHistory.push(url);
        zk.fancyboxIndex = zk.fancyboxHistory.length - 1;
        //++zk.fancyboxIndex;
    }

    $.fancybox({
        href: url, 
        type: 'ajax', 
        enableEscapeButton: false,  
        hideOnOverlayClick: false, 
        overlayColor : '#FFF', 
        centerOnScroll: true, 
        scrolling: 'no',
        //autoHeight : true,
        closeClick: false, 
        helpers: {
            overlay : {
                closeClick : false,
                background: '#fff'
            }
        }
    });
}

$.fn.extend({
    sendGateway: function(action){
        _form = this;
        _form.niftyOverlay('show');
        if(!action){
             action = this.attr('action');
             this.attr('action', '');
        }
        $('#ActionManager').remove();
        $('body').append('<iframe id="ActionManager" name="ActionManager" style="display: none"></iframe>');
        this.attr('method', 'POST');
        this.attr('target', 'ActionManager');
        this.attr('enctype','multipart/form-data');
        this.attr('action', action);
        form = document.getElementById(this.attr('id'));
        iframe = document.getElementById('ActionManager');
        form.submit();
    },
    sendForm: function(url, callback){
        _form = this;
       
        var formData = new FormData(_form[0]);

        $.ajax({
            url: url,
            type: 'POST',
            beforeSend: function(){
                _form.niftyOverlay('show');
            },
            processData: false,
            contentType: false,
            data: formData,
            dataType: 'json',
            success: function(r){
                if(callback) return callback(r);
            },
            complete: function(){
                _form.niftyOverlay('hide');
            },
            error: function(){
                alert('No se pudo realizar la petición');
            }
        });
    },
    changeGradoOptions: function(data){
        data = $.extend({value: '', showLabel: true, label: 'Seleccione'}, data);
        var _form = this;
        var _nivel = $('[id="nivel_id"]', $(_form));
        var _grado = $('[id="grado"]', $(_form));
        //console.log(_nivel, _grado)
        _nivel.bind('change', function(){
            if(this.value == '' || this.value == null) return false;
            _grado.find('option').remove();
            _data = NIVELES[this.value];
            if(data.showLabel !== false) _grado.append('<option value="">-- '+ data.label +' --</option>');
            //console.log(_grado)
            for(i=_data.grado_minimo;i<=_data.grado_maximo;i++){
                _grado.append('<option value="'+ i +'" '+ (i == data.value ? 'selected' : '') +'>'+ i +''+ (_data.definicion_grado == 1 ? ' Años' : 'º Grado') +'</option>');
            }
            if(_data.avanzada == 'SI'){
                _grado.append('<option value="-1" '+ (-1 == data.value ? 'selected' : '') +'>Avanzada</option>');
            }
        });
        
        _nivel.trigger('change');
    }
});

/* Set the defaults for DataTables initialisation */
if($.fn.dataTable)
    $.extend(true, $.fn.dataTable.defaults, {
        "iDisplayLength": 100,
        "pageLength": 100,
        "sDom": "<'row'<'col-sm-6'l><'col-sm-6'f>r>" + "t" + "<'row'<'col-sm-6'i><'col-sm-6'p>>",
        "responsive": true,
        "oLanguage": {
            "sLengthMenu": "_MENU_ registros por página",
            //"sLengthMenu": "Mostrar _MENU_ por página",
            "sZeroRecords": "No se encontró ningun registro",
            "sInfo": "Mostrando _START_ - _END_ de _TOTAL_",
            "sInfoEmpty": "Mostrando 0 - 0 de 0",
            "sEmptyTable": "No hay datos disponibles",
            "sInfoFiltered": "(filtrado de _MAX_ en total)",
            "sSearch":"Filtrar:",
            "oPaginate": {
                "sFirst":    "Primero",
                "sPrevious": '<i class="fa fa-angle-left"></i>',
                "sNext":     '<i class="fa fa-angle-right"></i>',
                "sLast":     "Último"
            }
        },
    });

$(window).on('keydown', function(e){
    if(e.keyCode == 121){
        zk.reloadPage();
    }
    if(e.keyCode == 120){
        $.fancybox.reload();
    }
    //console.log(e.keyCode);
})


function formatBytes(bytes,decimals) {
   if(bytes == 0) return '0 Byte';
   var k = 1000; // or 1024 for binary
   var dm = decimals + 1 || 3;
   var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
   var i = Math.floor(Math.log(bytes) / Math.log(k));
   return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
}

function selectChangeRoleWindow(r){
    var message = '<div class="form-block">';
    for(i in r.roles){
        message += '<button class="btn btn-block btn-primary" onclick="doChangeRole(\''+ r.roles[i] +'\', \''+ r.token +'\')">'+ r.roles[i] +'</button>';
    }
    message += '</div>';

    bootbox.dialog({
        title: "Seleccione un rol",
        message: message,
        size: 'small'
    });
}

function doChangeRole(role, token){
    $.post('/usuarios/change_role', {role: role, token: token}, function(r){
        if(parseInt(r[0]) == 1){
            window.location = '/';

        }else{
            $.prompt('Operación fallida');
        }
    }, 'json');
}

function selectChangeSedeWindow(r){
    var message = '<div class="form-block">';
    for(i in r.sedes){
        message += '<button class="btn btn-block btn-primary" onclick="doChangeSede(\''+ r.sedes[i].id +'\', \''+ r.token +'\')"><b>'+ r.sedes[i].nombre.toUpperCase() +'</b></button>';
    }
    message += '</div>';

    bootbox.dialog({
        title: "Seleccione Sede",
        message: message,
        size: 'small'
    });
}

function doChangeSede(sede_id, token){
    $.post('/usuarios/change_sede', {sede_id: sede_id, token: token}, function(r){
        if(parseInt(r[0]) == 1){
            window.location = '/';

        }else{
            $.prompt('Operación fallida');
        }
    }, 'json');
}


function  ckEditorVerySimple(selector, editorVar){
    if(!editorVar)
        editorVar = "editor";

    ClassicEditor
            .create( document.querySelector( selector ), {
                
                toolbar: {
                    items: [
                        
                        'bold',
                        'italic',
                        'bulletedList',
                        'numberedList',
                        'alignment',
                        'imageInsert',
                        'fontBackgroundColor',
                        'fontColor',
                        'fontSize',
                        'fontFamily',
                        'highlight',
                        'insertTable',
                        
                    ],
                    shouldNotGroupWhenFull: true
                },
                language: 'es',
                image: {
                    toolbar: [
                        'imageTextAlternative',
                        'imageStyle:full',
                        'linkImage',
                        //'imageStyle:side',
                    
                        'imageStyle:alignLeft',
                        'imageStyle:alignCenter',
                        'imageStyle:alignRight',
                        
                    ],
                    styles: [
                        // This option is equal to a situation where no style is applied.
                        'full',

                        'alignCenter',
                        // This represents an image aligned to the left.
                        'alignLeft',

                        // This represents an image aligned to the right.
                        'alignRight'
                    ],
                    resizeUnit: 'px',
                },
                table: {
                    contentToolbar: [
                        'tableColumn',
                        'tableRow',
                        'mergeTableCells',
                        'tableCellProperties',
                        'tableProperties'
                    ]
                },
                licenseKey: '',
                simpleUpload: {
                    // The URL that the images are uploaded to.
                    uploadUrl: '/home/upload_image',

                    // Enable the XMLHttpRequest.withCredentials property.
                    withCredentials: true,

                    // Headers sent along with the XMLHttpRequest to the upload server.
                    headers: {
                        'X-CSRF-TOKEN': $("meta[name='csrf-token']").attr("content"),
                        //Authorization: 'Bearer <JSON Web Token>'
                    }
                }
                
            } )
            .then( editor => {
                window[editorVar] = editor;
            } )
            .catch( error => {
                console.error( 'Oops, something went wrong!' );
                console.error( 'Please, report the following error on https://github.com/ckeditor/ckeditor5/issues with the build id and the error stack trace:' );
                console.warn( 'Build id: wrkpprsd1v44-c3v5ops1ycd' );
                console.error( error );
            } );
}