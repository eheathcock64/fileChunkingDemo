public class fileChunking {

  /*
    @ Method Name      : getBloblFromImageUrl
    @ Created by       : Evan Heathcock
    @ Description      : return a blob from image url - performs get requests in increments of 400000 bytes
  */

    public class BlobFromUrlWrapper {
        @AuraEnabled
        public String blobPart;
        @AuraEnabled
        public Boolean hasMoreData;
    }

    @AuraEnabled(cacheable=true)
    public static BlobFromUrlWrapper getBloblFromImageUrl(String imageUrl, Integer offset){
        //create wrapper for Blob part
        String BlobPart = '';
        BlobFromUrlWrapper response = new BlobFromUrlWrapper();

        //create request and set range in header
        HttpRequest req = new HttpRequest();
        req.setHeader('Range', 'bytes= ' + ((offset * 47999) + (offset)) + '-' + (((offset + 1) * 47999) +(offset)));
     	req.setEndpoint(imageUrl);
     	req.setMethod('GET');

        //send GET request
     	Http http = new Http();
     	HTTPResponse res = http.send(req);

		//process response as a blob and encode to base64 for wrapper
     	blob image = res.getBodyAsBlob();
     	BlobPart = (EncodingUtil.base64Encode(image));

        //If beggining of chunking, add prefix
        if(offset == 0){
                BlobPart = 'data:'+res.getHeader('Content-Type')+';base64,' +  BlobPart;
            }

        //determine if image has more base64 to retrieve and pass to wrapper
     	Integer length = Integer.valueOf(res.getHeader('Content-Length'));
            if(length < (48000)){
          		response.hasMoreData = false;
            }
        	else{
            	response.hasMoreData = true;
        }

     response.blobPart = BlobPart;
     return response;
    }

	@AuraEnabled(cacheable=true)
	public static BlobFromUrlWrapper getBloblFromImageUrlNoChunk(String imageUrl){
        //create wrapper for Blob part
        String BlobPart = '';
        BlobFromUrlWrapper response = new BlobFromUrlWrapper();

        //create request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(imageUrl);
     	req.setMethod('GET');

        //send GET request
     	Http http = new Http();
     	HTTPResponse res = http.send(req);

		//process response as a blob and encode to base64 for wrapper
     	blob image = res.getBodyAsBlob();
     	BlobPart = (EncodingUtil.base64Encode(image));


     response.blobPart = BlobPart;
     return response;
    }

}
