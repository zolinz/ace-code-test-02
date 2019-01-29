node {

    imageName = "mycluster.icp:8500/ace/aceappzoli-"+env.BUILD_NUMBER



   stage('clone repo'){
   echo imageName
   echo JENKINS_HOME
   echo WORKSPACE
    checkout scm
   }
/*

   stage('clone app source code'){
    git branch: 'master', url: 'https://github.com/zolinz/ace-code-test-02.git'
   }
*/

   stage('build bar file'){
     sh """#!/bin/bash
            echo "********** setting up XVBF and mqsiprofile ***************"
            /usr/bin/Xvfb :100 &
             export DISPLAY=":100"
             cd /opt/ibm/ace-11.0.0.2
             ./ace make registry global accept license silently
            . /opt/ibm/ace-11.0.0.2/server/bin/mqsiprofile

            #cd /root/workspace
            #pwd
            #echo \$OLDPWD
            #ls | egrep  '.*[^tmp]\$'
            #CODE_DIR=`ls | egrep  '.*[^tmp]\$'`
            #export CODE_DIR
            #echo \$CODE_DIR
            #sleep infinity
            #echo /root/workspace/\${CODE_DIR}
            cd $WORKSPACE
            echo "**************** create BAR file **************************"
            mqsicreatebar -data $WORKSPACE/ -b myapplicaion01.bar -a MyRest2
            mqsicreatebar -data $WORKSPACE/ -b myapplication01.bar -a MyRest2

            mkdir bars_aceonly
            chmod 777 bars_aceonly
            cp myapplication01.bar bars_aceonly
       """

   }


   stage('build image and push to ICP registry'){
        echo "*********** build ace image with BAR file then push to ICP registry ***************"
        sh """
        #!/bin/bash
        docker login  -u admin -p admin mycluster.icp:8500
        docker build -t ${imageName} .
        docker push ${imageName}
        """
   }

/*

   stage('test helm install'){
    sh"""
    #!/bin/bash

   #kubectl create serviceaccount --namespace kube-system tiller
   #kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
   #kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

   #sysctl -w net.ipv6.conf.all.disable_ipv6=1


   helm init --client-only --debug
   sleep infinity
   helm version --tls
   helm list --tls



    """
   }

*/
   stage('deploy new image'){
        echo "******************* patch deployment with new image then rollout *****************"
        sh """
        docker login  -u admin -p admin mycluster.icp:8500
        echo aceappzoli-$env.BUILD_NUMBER
       kubectl get image aceappzoli-$env.BUILD_NUMBER  -n=ace -o yaml | sed 's/scope: namespace/scope: global/g' | kubectl replace -f -
         kubectl set image deployment/zoli-ace-01-ibm-ace zoli-ace-01-ibm-ace=${imageName}


         kubectl rollout status deployment/zoli-ace-01-ibm-ace

        """

   }


}
