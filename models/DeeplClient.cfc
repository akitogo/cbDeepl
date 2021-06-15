/*

Implements deepl Api for Coldbox Coldfusion
See https://www.deepl.com/api.html

You will need a deepl to work with this API


Written by Akitogo Team
http://www.akitogo.com

*/
component hint="" accessors="true" Singleton{

	property name="uri";
	property name="apiKey";

	variables.uri='https://api.deepl.com/v1/';
	variables.httpTimeout=5;
	
	variables.aSupportedLanguages=[];
	
	/*  
	 * 
	 */
	public DeeplClient function init(
		string apiKey
		,string uri
	) {
		variables.apikey=apiKey;
		if (StructKeyExists(Arguments, 'uri')) {
			variables.uri=arguments.uri;
		}		
		
		//set once supported languges
		variables.aSupportedLanguages=getLanguages();
		
		return this;
	}

	/*  
	 * checks if language is supported
	 */
	public boolean function isSupportedLanguage(
		string language
	) {
		return javacast('boolean',arrayfindnocase(variables.aSupportedLanguages,language));
	}
	
	
	/*
	 * returns supported languages
	 */
	public array function getLanguages( ) {
		var json = sendRequest(
			endpoint = "languages"
		);
		var fullResponse = deserializeJSON(json);
		var langItem = {}; // language: The language code of the given language. name: Native name of the language.
		var ret = [];
		for (langItem in fullResponse) {
			arrayAppend(ret, langItem.language);
		}
		return ret;
	}

	
	/*  
	 * @text.hint text to be translated
	 * @source.hint source language
	 * @target.hint target language
	 */
	public function translate(
		string text
		,string source=''
		,string target
	) {
		var json            = sendRequest(endpoint="translate",text=text,source_lang=source,target_lang=target);
        var fullResponse    = deserializeJson(json);

		return fullResponse.translations[1].text;
	}


	/*  
	 * sends http request and checks for error
	 */	
	public string function sendRequest(
		// we don't need to set arguments here
	) {	 	
	    var httpService = new http(); 
	    httpService.setMethod("GET"); 
	    httpService.setCharset("utf-8"); 
	    if(structKeyExists(arguments,'endpoint'))
	    	httpService.setUrl("#variables.uri##arguments.endpoint#");
		else
	    	httpService.setUrl("#variables.uri#");
	    httpService.settimeout(variables.httpTimeout);

		// add api key first
		httpService.addParam(type="URL", name="auth_key", value="#variables.apiKey#");

		// then loop over all arguments and add them as url parameter
		for(var param in arguments){
			if(arguments[param] neq "" and param neq "endpoint")			
		 	   httpService.addParam(type="URL", name="#param#", value="#arguments[param]#");
		}
		var httpResponse = httpService.send().getPrefix();
		
		checkForError(httpResponse);
		
	    return httpResponse.FileContent;
	}	    

	/*  
	 * we are checking the http status code
	 * successful translation should return 200
	 * 
	 * if error, we throw and add message
	 */	
	private void function checkForError(
		httpResponse
	) {	
		switch(httpResponse.status_code){
			case '200':
				return;
			case '400':
				throw('Wrong request, please check error message and your parameters.');
				break;
			case '403':
				throw('Authorization failed. Please supply a valid auth_key parameter.');
				break;
			case '413':
				throw('Request Entity Too Large. The request size exceeds the current limit.');
				break;
			case '429':
				throw('Too many requests. Please wait and send your request once again.');
				break;
			case '456':
				throw('Quota exceeded. The character limit has been reached.');
				break;	
			default:
				throw('Status code not handled');
				break;				
		}
	}
}
