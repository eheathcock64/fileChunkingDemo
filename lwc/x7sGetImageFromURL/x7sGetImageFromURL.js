import { LightningElement, api } from 'lwc';
import getBloblFromImageUrl from '@salesforce/apex/fileChunking.getBloblFromImageUrl';

export default class x7sGetImageFromURL extends LightningElement {
    @api fileUrl;
    fileData;


    async getImageData(url, offset, blobParts) {
        console.log('Working on file chunk: ' + offset);
        let imageData = await getBloblFromImageUrl({ imageUrl: url, offset: offset });
        blobParts.push(imageData.blobPart);
        if (imageData.hasMoreData) {
            return await this.getImageData(url, offset + 1, blobParts);
        } else {
            let data = JSON.parse(JSON.stringify(imageData));
            data.blobParts = blobParts;
            data.offset = offset;
            return Promise.resolve(data);
        }
    }

    async chunkFile() {
        try {
            let promiseArray = [];
            console.log('Retrieving file: ' + this.fileUrl);
            try {
                promiseArray.push(this.getImageData(this.fileUrl, 0, []));
            } catch (error) {
                console.error(error);
                console.error('blob error:', this.fileUrl);
            }
            Promise.all(promiseArray).then(resultList => {
                resultList.forEach(result => {
                    if (result) {
                        this.fileData = result.blobParts.join('');
                        console.log('File Chunking complete, displaying image!');
                    }
                });
            }).catch(error => {
                console.error(error);
            })
        } catch (error) {
            console.error('error occured when chunking:', error);
        }
    }
}