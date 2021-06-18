import { LightningElement, wire } from 'lwc';

import getVFOrigin from '@salesforce/apex/lwcvfController.getVFOrigin';

import queryAccount from '@salesforce/apex/lwcvfController.queryAccount';

export default class Query50kPlusRows extends LightningElement {



    error;
    AccountIds;
    lstAccounts=[];


    @wire(getVFOrigin)
    vfOrigin;

    connectedCallback() {
        window.addEventListener("message", this.handleVFResponse.bind(this));
    }

    handleVFResponse(message) {
        if (message.origin === this.vfOrigin.data) {
            console.log('Came back to lightning');
            //console.log(JSON.stringify(message.data));
            this.AccountIds=message.data;
            let allAcc=[];
            queryAccount({ids:this.AccountIds}).then(data=>{
                console.log('Came Back');
               if(data.isAccLeft){
                     this.handleLeftData(data.leftAccids,data.currentAccount,data.isAccLeft);
               }
               else{
                this.lstAccounts=concatArray;

               }
            //console.log(JSON.stringify(data.leftAccids));

            }).catch(errpr =>{

            });

            console.log(this.lstAccounts.length);
        }
    }
    handleLeftData(leftIds,lstAcc,isLeft){
     console.log('Came to Handle rest Accs'+isLeft);
        
            queryAccount({ids:leftIds}).then(data=>{
                console.log('came to handle more dataasdasdsadadad');
                  //console.log(data.currentAccount);
                  //console.log('Previous Data');
                  //console.log(lstAcc);
                  lstAcc.push.apply(lstAcc, data.currentAccount);
                  console.log('Concating happen');
                  console.log(lstAcc);
                if(data.isAccLeft){
                     this.handleLeftData(data.leftAccids,lstAcc,data.isAccLeft);
               }
               else{

                this.lstAccounts=concatArray;

               }
           

            }).catch(errpr =>{

            });



    }



    handleFiretoVF() {
        this.template.querySelector("iframe").contentWindow.postMessage('TestMSg', this.vfOrigin.data);
    }

}