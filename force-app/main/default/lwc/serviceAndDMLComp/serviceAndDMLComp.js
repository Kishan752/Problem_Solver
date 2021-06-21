import { LightningElement } from 'lwc';

import makeServiceCall from '@salesforce/apex/ServiceDMLController.makeServiceCall';

export default class ServiceAndDMLComp extends LightningElement {
    pincode="";

    handleChange(event){
      this.pincode=event.target.value;
      console.log(event.target.value);
    }
    handlePincode(){
        makeServiceCall({'pincode': this.pincode}).then(response =>{
           console.log(response);
        }).catch(error=>{

        });
    }
}