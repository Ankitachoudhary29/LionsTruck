({
    getAssetdetails : function(component, event) {
		var action = component.get("c.fetchAssetDetails");
		action.setParams({
            assetId: component.get("v.recordId")
        });
        component.set("v.loading", true);
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            var state = a.getState();
            if(state==="SUCCESS") {
                component.set("v.loading", false);
                //location.reload();
                if(result != '' && result != null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "ERROR",
                        "message": result
                    });
                    component.set("v.showError",true);
                    component.set("v.errorMessage",result);
                    toastEvent.fire();
                } else {
                    component.set("v.showError",false);
                    component.set("v.showSuccess",true);
                    component.set("v.successMessage",'Asset Details are fetched');
                }
            } else if(state === "ERROR"){
                var errors = a.getError();                       
                component.set("v.showError",true);
                component.set("v.errorMessage",errors[0].message);
                
                component.set("v.loading", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "ERROR",
                    "message": errors[0].message
                });
                
                toastEvent.fire();
            }
            $A.get('e.force:refreshView').fire();
            var closequickVar = $A.get("e.force:closeQuickAction");
            
        });
        $A.enqueueAction(action);
	},
})