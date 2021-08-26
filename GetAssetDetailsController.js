({
	doInit: function(component, event, helper) {
		helper.getAssetdetails(component, event);
        //$A.get("e.force:closeQuickAction").fire();
	},
})