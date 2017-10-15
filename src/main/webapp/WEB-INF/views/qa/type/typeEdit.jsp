<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#typeEditForm').form({
            url : '${path }/type/edit',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                return isValid;
            },
            success : function(result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    var form = $('#typeEditForm');
                    parent.$.messager.alert('错误', eval(result.msg), 'error');
                }
            }
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
        <form id="typeEditForm" method="post">
            <table class="grid">
                <tr>
                    <td>类别名称</td>
                    <td>
                        <input name="typeId" type="hidden"  value="${type.typeId}">
                        <input name="updateDate" type="hidden"  value="${type.updateDate}">
                        <input name="typeName" type="text" placeholder="请输入类别名称" class="easyui-validatebox" data-options="required:true" value="${type.typeName}">
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>