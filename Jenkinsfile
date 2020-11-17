node {

    def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    def SF_USERNAME=env.SF_USERNAME
    def SERVER_KEY_CREDENTIALS_ID=env.SERVER_KEY_CREDENTIALS_ID
    def DEPLOYDIR='manifest/'
    def TEST_LEVEL='RunLocalTests'
    def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://test.salesforce.com" 

    //def toolbelt = tool 'toolbelt'


    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------

    stage('checkout source') {
        checkout scm
        sh "New-Item .\\ -Name ChangedFiles -type directory"
    	sh "git diff HEAD~ --name-only  | Copy-Item -Destination .\\ChangedFiles\\ -Recurse"
    	sh "New-Item .\\ChangedFiles\\ -Name ChangedMeta -type directory"
    	sh "Get-ChildItem -Path .\\ChangedFiles\\ -exclude ChangedMeta,*.xml,*.cfg,*.yml | Copy-Item -Destination .\\ChangedFiles\\ChangedMeta -Recurse -PassThru"
    	sh "Get-ChildItem -Path .\\ChangedFiles\\ChangedMeta -exclude *.xml | Rename-Item -NewName { $_.Name +'-meta.xml' }"
	sh "ls .\\ChangedFiles\\ChangedMeta -exclude *.txt | % Name  > .\\ChangedFiles\\ChangedMeta\\SearchforMeta.txt "
	sh "$files=Get-Content .\\ChangedFiles\\ChangedMeta\\SearchforMeta.txt"
	sh "ForEach($file in $files){Get-ChildItem -Path .\\force-app\\main\\default -recurse | Where-Object { \$_.Name -match \$(\$file) } | Copy-Item -Destination .\\ChangedFiles}"
	sh "Remove-Item -Recurse -Force .\\ChangedFiles\\ChangedMeta"
    }


    // -------------------------------------------------------------------------
    // Run all the enclosed stages with access to the Salesforce
    // JWT key credentials.
    // -------------------------------------------------------------------------

 	withEnv(["HOME=${env.WORKSPACE}"]) {	
	
	    withCredentials([file(credentialsId: SERVER_KEY_CREDENTIALS_ID, variable: 'server_key_file')]) {
		// -------------------------------------------------------------------------
		// Authenticate to Salesforce using the server key.
		// -------------------------------------------------------------------------

		stage('Authorize to Salesforce') {
			rc = command "sfdx force:auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --jwtkeyfile AfdasJenkins.key --username ${SF_USERNAME}"
		    if (rc != 0) {
			error 'Salesforce org authorization failed.'
		    }
		}


		// -------------------------------------------------------------------------
		// Deploy metadata and execute unit tests.
		// -------------------------------------------------------------------------

		stage('Deploy and Run Tests') {
		    rc = command "sfdx force:mdapi:deploy --wait 10 --deploydir ${DEPLOYDIR} -u ${SF_USERNAME} --testlevel ${TEST_LEVEL}"
		    if (rc != 0) {
			error 'Salesforce deploy and test run failed.'
		    }
		}


		// -------------------------------------------------------------------------
		// Example shows how to run a check-only deploy.
		// -------------------------------------------------------------------------

		//stage('Check Only Deploy') {
		//    rc = command "$sfdx force:mdapi:deploy --checkonly --wait 10 --deploydir ${DEPLOYDIR} --targetusername UAT --testlevel ${TEST_LEVEL}"
		//    if (rc != 0) {
		//        error 'Salesforce deploy failed.'
		//    }
		//}
	    }
	}
}

def command(script) {
    if (isUnix()) {
        return sh(returnStatus: true, script: script);
    } else {
		return bat(returnStatus: true, script: script);
    }
}
