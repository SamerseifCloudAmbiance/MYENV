node {

    def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    def SF_USERNAME=env.SF_USERNAME
    def SERVER_KEY_CREDENTIALS_ID=env.SERVER_KEY_CREDENTIALS_ID
    def DEPLOYDIR='ChangedFiles/'
    def TEST_LEVEL='NoTestRun'
    def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://test.salesforce.com" 
    def SourcesDirectory = "."

    //def toolbelt = tool 'toolbelt'


    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------

    stage('checkout source') {
        checkout scm
        powershell "New-Item ${SourcesDirectory} -Name ChangedFiles -type directory"
    	command "echo ChangedFiles"
   	powershell "Copy-Item  -Path ${SourcesDirectory}\\manifest\\package.xml -Destination ${SourcesDirectory}\\ChangedFiles\\ -Recurse -force"
    	powershell "git diff HEAD~ --name-only  | Copy-Item -Destination ${SourcesDirectory}\\ChangedFiles\\ -Recurse -Exclude Jenkinsfile"
     	command "echo ChangedFiles"
    	powershell "New-Item ${SourcesDirectory}\\ChangedFiles\\ -Name ChangedMeta -type directory"
    	command "echo \"Get-ChildItem -Path ${SourcesDirectory}\\ChangedFiles\\ -exclude ChangedMeta,Jenkinsfile,*.xml,*.cfg,*.yml | Copy-Item -Destination ${SourcesDirectory}\\ChangedFiles\\ChangedMeta\\ -Recurse -PassThru \""
    	powershell "Get-ChildItem -Path ${SourcesDirectory}\\ChangedFiles\\ -exclude ChangedMeta,Jenkinsfile,*.xml,*.cfg,*.yml | Copy-Item -Destination ${SourcesDirectory}\\ChangedFiles\\ChangedMeta\\ -Recurse -PassThru"
    	command "echo \"Get-ChildItem -Path ${SourcesDirectory}\\ChangedFiles\\ChangedMeta\\ -exclude *.xml | Rename-Item -NewName {\$_.Name +'-meta.xml'}\""
    	powershell "Get-ChildItem -Path ${SourcesDirectory}\\ChangedFiles\\ChangedMeta\\ -exclude *.xml | Rename-Item -NewName {\$_.Name +'-meta.xml'}"
	command "echo Rename"
    	powershell "ls ${SourcesDirectory}\\ChangedFiles\\ChangedMeta\\ -exclude *.txt | % Name  > ${SourcesDirectory}\\ChangedFiles\\ChangedMeta\\SearchforMeta.txt "
	command "echo ls"
    	powershell "\$files=Get-Content ${SourcesDirectory}\\ChangedFiles\\ChangedMeta\\SearchforMeta.txt"
	command "echo Get-Content"
    	powershell "ForEach(\$file in \$files){Get-ChildItem -Path ${SourcesDirectory}\\force-app\\main\\default -recurse | Where-Object { \$_.Name -match \$(\$file) } | Copy-Item -Destination ${SourcesDirectory}\\ChangedFiles}"
   	command "echo ChangedMeta"
	powershell "Remove-Item -Recurse -Force ${SourcesDirectory}\\ChangedFiles\\ChangedMeta\\"
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
		    rc = command "sfdx force:source:deploy --wait 10 --deploydir ./ChangedFiles/schema.xml -u ${SF_USERNAME} --testlevel ${TEST_LEVEL}"
		    if (rc != 0) {
			error 'Salesforce deploy and test run failed.'
		    }
		    else{
			   // powershell "Remove-Item -Recurse -Force ${SourcesDirectory}\\ChangedFiles"
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
