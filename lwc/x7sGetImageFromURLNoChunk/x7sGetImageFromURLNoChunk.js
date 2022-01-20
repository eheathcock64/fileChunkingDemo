import { LightningElement, api, track } from 'lwc';
import getBloblFromImageUrl from '@salesforce/apex/fileChunking.getBloblFromImageUrlNoChunk';

export default class x7sGetImageFromURLNoChunk extends LightningElement {
    @api fileUrl;

    @track fileData;
    @track errorMsg;

    handlegetBloblFromImageUrlNoChunk() {
        getBloblFromImageUrl({ imageUrl: this.fileUrl })
            .then(result => {
                this.fileData = result;
            })
            .catch(error => {
                console.log('Error occured: ' + JSON.stringify(error));
                this.errorMsg = JSON.stringify(error);
            })
    }
}
