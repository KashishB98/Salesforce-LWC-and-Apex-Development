import { LightningElement,api,wire } from 'lwc';
import FIRST_NAME from "@salesforce/schema/Contact.FirstName";
import LAST_NAME from "@salesforce/schema/Contact.LastName";
import TITLE_FIELD from "@salesforce/schema/Contact.Title";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
export default class LightningEditForm extends LightningElement {

FIRSTNAME = FIRST_NAME
LASTNAME = LAST_NAME
TITLEFIELD = TITLE_FIELD
EMAILFIELD = EMAIL_FIELD

@api recordId

}