import { LightningElement, wire } from 'lwc';
import { IsConsoleNavigation, getFocusedTabInfo, closeTab } from 'lightning/platformWorkspaceApi';

export default class WorkSpaceApiMethods extends LightningElement {

    @wire(IsConsoleNavigation)
    isConsoleNavigation

    // close the focused tab
    closeTabHandler() {
        if (this.isConsoleNavigation) {
            // getting focused tab Id
            getFocusedTabInfo()
                .then(tabInfo => {
                    closeTab(tabInfo.tabId)
                })
                .catch(error => {
                    console.log('Error occured while closing tabs');
                })
        }
    }

    // close all sub tabs
    closeSubTabHandler() {
        console.log('in handler ');
        if (this.isConsoleNavigation) {
            getFocusedTabInfo()
                .then(tabInfo => {
                    if (tabInfo.subtabs) {
                        tabInfo.subtabs.forEach(tab => {
                            console.log('tab info data is ', tab);
                            closeTab(tab.tabId)
                        });
                    }
                })
        }
    }
}