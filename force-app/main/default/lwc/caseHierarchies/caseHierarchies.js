import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getCasesWithChildrenByParentId from '@salesforce/apex/CaseHierarchiesController.getCasesWithChildrenByParentId'

const COLUMNS = [
    { fieldName: 'nameUrl',label: 'Case Number',type: 'url',typeAttributes: {label: { fieldName: 'CaseNumber' },target: '_self'}},
    { fieldName: 'Origin', label: 'Case Origin', type: 'text' },
    { fieldName: 'Subject', label: 'Case Subject', type: 'text' }
]

export default class CaseHierarchies extends LightningElement {
    gridColumns = COLUMNS
    @track gridData
    @api recordId
    expandedRows = [];
    isHierarchies

    connectedCallback() {
        this.getCaseHierarchies();
    }

    /**************************************************************************************************************************************************
    * @description     This function is called with Connected and also in handleToggle when user clicks on toggle and performing following actions
    *                      1) Calling Apex method with current detail page Id and fetching the child cases by current parent Id
    * @param           parentId is the variable that represents the current page Id
    ***************************************************************************************************************************************************/
    getCaseHierarchies() {
        getCasesWithChildrenByParentId({ parentId: this.recordId })
            .then(data => {
                let parseData = JSON.parse(JSON.stringify(data));
                let expandedRowsInfo = []
                for (let i = 0; i < parseData.length; i++) {
                    parseData[i].nameUrl = `/${parseData[i].Id}`;
                    if (parseData[i]["Cases"]) {
                        parseData[i]._children = parseData[i]["Cases"];
                        let parsChildren = parseData[i]._children
                        parseData[i]._children = parsChildren.map((caseData) =>
                            ({
                                _children: [],
                                ...caseData,
                                nameUrl: `/${caseData.Id}`
                            }))
                        expandedRowsInfo.push(parseData[i].Id)
                        delete parseData[i].Cases

                    } else {
                        parseData[i]._children = []
                    }
                }
                this.gridData = parseData
                this.expandedRows = expandedRowsInfo

                 // Checking if data is present, If not changing isHierarchies variable
                if (this.gridData.length > 0) {
                    this.isHierarchies = true
                } else {
                    this.isHierarchies = false
                }
            })
    }

    handleOnToggle(event) {
        const rowId = event.detail.name;
        if (!event.detail.hasChildrenContent && event.detail.isExpanded) {

            // Calling Apex method if row is not expanded and not having children property
            getCasesWithChildrenByParentId({ parentId: rowId })
                .then((result) => {
                    if (result && result.length > 0) {
                        const newChildren = result.map((child) => ({
                            _children: [],
                            ...child,
                            nameUrl: `/${child.Id}`
                        }));
                        this.gridData = this.getNewDataWithChildren(
                            rowId,
                            this.gridData,
                            newChildren
                        );
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: "No children",
                                message: "No children for the selected Case",
                                variant: "warning"
                            })
                        );
                    }
                })
                .catch((error) => {
                    console.log("Error loading child cases", error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Error Loading Children Cases",
                            message: error + " " + error ?.message,
                            message: "Error occurred",
                            variant: "error"
                        })
                    );
                })
        }
    }

    getNewDataWithChildren(rowId, data, children) {
        return data.map((row) => {
            let hasChildrenContent = false;
            if (
                Object.prototype.hasOwnProperty.call(row, "_children") &&
                Array.isArray(row._children) &&
                row._children.length > 0
            ) {
                hasChildrenContent = true;
            }

            if (row.Id === rowId) {
                row._children = children;
            } 
            else if (hasChildrenContent) {
                this.getNewDataWithChildren(rowId, row._children, children);
            }
            return row;
        });
    }
}