<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <meta charset="UTF-8">
    <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <script src="/statics/jquery/jquery-1.9.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/statics/bootstrap/css/bootstrap.min.css">
    <script src="/statics/bootstrap/js/bootstrap.min.js"></script>
    <script src="/statics/handsontable/dist/handsontable.full.min.js"></script>
    <link rel="stylesheet" media="screen" href="/statics/handsontable/dist/handsontable.full.min.css">
</head>
<body>
<div class="container">
    <div class="row text-center"><h2>动态字段表格</h2></div>
    <div id="detailTable" style="margin-left: 20px"></div>
    <div class="row" style="margin-top: 5px">
        <div class="col-md-4 col-md-offset-10">
            <button type="button" id="save" class="btn btn-success">保存</button>
        </div>
    </div>
</div>
</body>
<script>
    var autoColLen=0;
    var colHeaderData = [];
    var autoColumn=[];
    colHeaderData.push({
        xh: '序号',
        bzid: '车辆编号',
        name: '车辆名称',
        type: '车辆类型',
        total: '车辆价格',
        fee1: '院承担部分',
        sfy: '所承担部分',
        notes:'备注'
    });
    $.ajax({
        type: 'get',
        url:"/learn/getAutoFields",
        dataType: "json",
        async:false,
        success: function (response) {
            if (response.success) {
                var list = response.attributes.list;
                autoColLen=list.length;
                var tempHeader={};
                for(var i in list){
                    tempHeader[list[i]['field']]=list[i]['name'];
                    autoColumn.push({data:list[i]['field'],type:'numeric',readOnly:false,formate:'00.00'});
                }
               colHeaderData.push(tempHeader);
            } else {
                alert(response.message);
            }
        }
    });

    var columns = [
        {data: "xh", type: 'numeric', readOnly: false},
        {data: "bzid", type: 'text', readOnly: false},
        {data: "name", type: 'text', readOnly:true},
        {data: "type", type: 'text', readOnly: true},
        {data: "total", type: 'numeric',format: '00.00', readOnly: false}
    ];
    columns=columns.concat(autoColumn);
    columns.push({data: "sfy", type: 'numeric', readOnly: false, format: '00.00'}, {data: "notes", type: 'text', readOnly: false});
    var testData = [];
    testData.push({
        xh: '1',
        bzid:'柱AN032943Y',
        name:'doge越野系列3',
        type:'越野',
        total:'1932921.73'
    });
    colHeaderData = colHeaderData.concat(testData);
    var container = document.getElementById('detailTable');
    var detailOptions = {
        persistentState: true,
        className: "htCenter",
        data: colHeaderData,
        dataSchema: null,
        colHeaders: [],
        columns: columns,
        minSpareRows: 1,
        minRows: 10,
        height: 600,
        fixedRowsTop:2,
        fixedColumnsLeft:5,
        rowHeaders: true,
        manualColumnResize: true,
        manualRowResize: true,
        formulas: true,
        autoRowSize: true,
        autoColumnSize:true,
        contextMenu:true,
        mergeCells: [
            {row: 0, col: 0, rowspan: 2, colspan: 1},//序号
            {row: 0, col: 1, rowspan: 2, colspan: 1},//编号
            {row: 0, col: 2, rowspan: 2, colspan: 1},//名称
            {row: 0, col: 3, rowspan: 2, colspan: 1},//类型
            {row: 0, col: 4, rowspan: 2, colspan: 1},//合计
            {row: 0, col: 5, rowspan: 1, colspan:autoColLen},//院承担
            {row: 0, col: 5+autoColLen, rowspan: 2, colspan: 1},//所承担
            {row: 0, col: 6+autoColLen, rowspan: 2, colspan: 1}
        ]
    };
    window.hot = new Handsontable(container, detailOptions);
    hot.updateSettings({
        cells:function(row,col,prop){
            var cellProperties={};
            if(row==0||row==1){
                cellProperties.className="htCenter htMiddle";//表头居中
                cellProperties.readOnly=true;//表头只读以及字体颜色
                cellProperties.readOnlyCellClassName="htSubmenu :after";
            }
            return cellProperties;
        }
    });

</script>
</html>