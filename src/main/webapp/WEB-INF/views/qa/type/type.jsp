<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var typeDataGrid;
    $(function() {
        typeDataGrid = $('#typeDataGrid').datagrid({
            url : '${path }/type/dataGrid',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            idField : 'typeId',
            sortName : 'updateDate',
            sortOrder : 'desc',
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            frozenColumns : [[
            	{ width : '100',  title : 'id',     	field : 'typeId', 		sortable : true },
            	{ width : '100',  title : '类别名称',	field : 'typeName', 	sortable : true },
	            { field : 'action', title : '操作', width : 130,
	                formatter : function(value, row, index) {
	                    var str = '';
	                        <shiro:hasPermission name="/type/edit">
//	                            str += $.formatString('<a href="javascript:void(0)" class="type-easyui-linkbutton-edit"  data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="editTypeFun(\'{0}\',\'{1}\');" >编辑</a>', row.typeId, row.updateDate);
                                str += $.formatString('<a href="javascript:void(0)" class="type-easyui-linkbutton-edit"  data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="editTypeFun(\'{0}\');" >编辑</a>', row.typeId);
                        </shiro:hasPermission>
	                        <shiro:hasPermission name="/type/delete">
	                            str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
	                            str += $.formatString('<a href="javascript:void(0)" class="type-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="deleteTypeFun(\'{0}\');" >删除</a>', row.typeId);
	                        </shiro:hasPermission>
	                    return str;
	                }}
	        ]],
            onLoadSuccess:function(data){
                $('.type-easyui-linkbutton-edit').linkbutton({text:'编辑'});
                $('.type-easyui-linkbutton-del').linkbutton({text:'删除'});
              	// 修复序号列宽度问题
    	        $(this).datagrid("fixRownumber");
            },
            toolbar : '#typeToolbar'
        });
    });


    function addTypeFun() {
        parent.$.modalDialog({
            title : '添加',
            width : 500,
            height : 300,
            href : '${path }/type/addPage',
            buttons : [ {
                text : '确定',
                handler : function() {
                    parent.$.modalDialog.openner_dataGrid = typeDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#typeAddForm');
                    f.submit();
                }
            } ]
        });
    }

    /**
     * @param id     类别ID
     * @param date 更新时间
     */
    function editTypeFun(id) {
        var typeId = id;
        if (typeId === undefined) {
            var rows = typeDataGrid.datagrid('getSelections');
            typeId = rows[0].typeId;

        } else {
            typeDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
        }
        parent.$.modalDialog({
            title : '编辑',
            width : 500,
            height : 300,
            href : '${path }/type/editPage?typeId=' + typeId,
            buttons : [ {
                text : '确定',
                handler : function() {
                    parent.$.modalDialog.openner_dataGrid = typeDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#typeEditForm');
                    f.submit();
                }
            } ]
        });
    }

    function deleteTypeFun(typeId) {
        if (typeId === undefined) {//点击右键菜单才会触发这个
            var rows = typeDataGrid.datagrid('getSelections');
            typeId = rows[0].typeId;
        } else {//点击操作里面的删除图标会触发这个
            typeDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
        }
        parent.$.messager.confirm('询问', '您是否要删除当前类别？', function(b) {
            if (b) {
                progressLoad();
                $.post('${path }/type/delete', {
                    typeId : typeId
                }, function(result) {
                    if (result.success) {
                        parent.$.messager.alert('提示', result.msg, 'info');
                        typeDataGrid.datagrid('reload');
                    }
                    progressClose();
                }, 'JSON');
            }
        });
    }

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',fit:true,border:false">
        <table id="typeDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="typeToolbar" style="display: none;">
    <shiro:hasPermission name="/type/add">
        <a onclick="addTypeFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">添加</a>
    </shiro:hasPermission>
</div>