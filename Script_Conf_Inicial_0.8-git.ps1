##########################################################
#	Script para Powershell // Versión 0.8 // 2020-07     #
##########################################################

# Funciones Varias para la configuración de un nuevo usuario en W10

#Indice de versiones.
$Global:vVersionInicial="Versión 0.0.1 // 2019-05"
$Global:vVersionActual="Versión 0.7 // 2019-07"
$Global:vVersionActual="Versión 0.8 // 2020-07"

# Indispensable!!, abrir PowerShell como Admin y ejecutar: "Set-ExecutionPolicy RemoteSigned" o "Set-ExecutionPolicy unrestricted"

function fnApuntes(){
    Clear-Host;
    Write-Host "
#Ejecutando Get-executionPolicy vemos el nivel de la directiva para la ejecución de Scripts
#Get-ExecutionPolicy -list la muestra en detalle
#La alteramos con el cmdlet Set-ExecutionPolicy RemoteSigned o Set-ExecutionPolicy unrestricted
#Podriamos volver a dejarla como está con Set-ExecutionPolicy Restricted

$vListFiles.GetType() => Saca el tipo del dato que contiene la variable

# `n Añade un salto de linea, Get-AppxPackage | Format-Table -Property Name filtro por nombre,
#Lista de programas instalados Get-Package -provider Programs -IncludeWindowsInstaller 
#OTRA lista de programas instalados, pero faltan. Get-WmiObject -Class win32_product
Get-packagesource => Fuestes dispo para instalar?? Get-packageprovider => ???

 variable.getType()
 Grep ==> | Select-String -Pattern xxxxx
 $_ => dentro de un metodo foreach hace referencia al item de esa iteración

 #dism /online /get-capabilities => Listado de Caracteristicas/funciones opcionales posibles
#/Remove-capability => para desinstalar
 #C:\Windows\Logs\DISM\dism.log
#dism /online /get-features => Listado de Caracteristicas de Windows posibles

$env:variable => acceso a la variable de entorno Ej: $env:temp ==> carpeta temp del usuario

if($?){} true o false del ultimo comando
#Establecer validez de parametros en funciones  Param (        [string]$pTexto,        [string]$pTipoTitulo    )
metodo substring

lanzar excepcion  [System.IO.File]::ReadAllText('C:\does\not\exist.txt')"


};
function fnHelp(){
    fnAddToLog("Llegada a fnHelp");
    fnEncabezado "Función de Ayuda" 2;
    Write-Host "`t1) Desactivar descarga inicial de Juegos y App´s recomendadas
    => Desactiva que para los nuevos usuarios se descarguen los Juegos y diversas app´s de M$. En cuanto inicies sesión en Win como tengas internet se instalarán si no has ejecutado primero esta opción.

    2) Desinstalar Aplicaciones Preinstaladas
    => Se desinstalar programas preinstalados por M$ que no se suelen usar en la empresa como por ejemplo Bing news, Xbox...etc  

    3) Activar NFS (NAS Unix) SMB-1 (Unirse Dominio) & SSH Server
    => Activar Caracteristica Client NFS para conectarse a NAS con sistema de ficheros Unix.
    => Activar SMB para la compatibilidad con el DC1 y poder unirse al Dominio actual.
    => Activar la característica SSH Server para poder conectarnos a este equipo via SSH.
    => Activar la versión 3.5 de .Net para programas BB/BE.

    4) Instalar Programas Checking-List
    => Lista los msi de la carpeta checking-list del 190 y los instala. Ojo, instalará todos los que encuentre. 

    5) Instalar Programas Checking-List
    => Coge los nombre y opciones de los .exe de un array para copiarlos del servidor 190 a local e instalarlos despues.

    6) Instalar BB y Actualizar a V 2.1.9
    => Pasa a %temp% los zip, los descomprime, ejecuta el instalador y luego pega la actualizacion para sustituir exe´s y dll´s
    
    7) Copiar TeamViewerQS 12
    ==> Copia TV a la carpeta C:\Users\Public\Downloads y crea acceso directo en C:\Users\Public\Desktop
    
    8) Instalar Adobe Reader DC
    ==> Se descarga el offline marcado en la función del ftp de adobe, lo instala desde %temp% del usuario.
    
    9) Desactivar la Ejecución de Scripts
    => Vuelve a dejar la opción de seguridad en el modo default para al ejecución de scripts de powershell.
    
    Menú Herramientas

    7) Mostrar los últimos registros del LOG
    => Muestra el LOG que contiene información sobre los procesos llevados a cabo con el script. Alojado en $env:temp.

    8) About this Script
    => Muestra bugs, errores conocidos que tiene el script y posibles mejoras para próximas versiones.

    9) Mostrar la ayuda sobre el menú inicial
    => Estás en ella.

    10) Salir
    => ^_^'" -ForegroundColor DarkYellow;
    write-host "";
    fnPressEnter;
};
function fnAbout(){
    fnAddToLog("Llegada a fnAbout");
    fnEncabezado "About this Script" 2;
    Write-Host "`tErrores conocidos" -ForegroundColor Yellow;
    Write-Host "`n`t*)La opción de instalar programas instalará todos los .msi de la ruta que tiene guardada por lo que puede haber conflictos si ve varios .msi del mismo programa pero de distintas versiones.
    `n`t*)No está comprobado que la opción 1 para evitar la descarga de juegos funcione. En los foros, salvo las opciones de editar politicas de dominio, parecen que dejan de funcionar cada vez que M$ saca una nueva versión de Windows.
    `n`t*)Sin una ''source'' indicada en el comando, las caracteristicas opcionales fallarán al instalarse si no hay internet.";
    Write-Host "`n`tCaracterísticas" -ForegroundColor Yellow;
    Write-Host "`n`t*)Implementado un control de excepciones en las funciones principales.
    `n`t*)LOG activo en la carpeta temporal del usuario.
    `n`t*)Control de errores incorporado en algunos pasos de las funciones.
    `n`t*)Función para la instalación de ficheros .exe y .msi incluida, ya instala 12 app´s)";
    write-host "`n";
    fnPressEnter;
};
function fnMostrarLog(){
    fnAddToLog("Llegada a fnMostrarLog");
    $vPath=$env:temp + "\" + "Log_Script_Instalacion_Powershell.txt";
    fnEncabezado "Mostrar los últimos 30 registros del LOG" 2;    
    Write-host "`tFichero LOG alojado en $vPath";    
    Write-host "";
    Try{
        Get-Content $vPath -Tail 30;
    }
    Catch{
        fnInception 'fnDesactivarEjecucionScripts' "`t$($_.Exception.GetType().FullName)";
        }
    Finally{  
        Remove-Variable vPath;
        };
    fnDeco02; 
    fnPressEnter;
};
function fnDesactivarEjecucionScripts(){
    fnAddToLog "Llegada a fnDesactivarEjecucionScripts";
    fnEncabezado "Desactivar la Ejecución de Scripts" 2;
    Write-host "`tLa ejecución de este comando evitará la proxima ejecución del script";
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    if ($vChoice -eq "s"){
        Try{
            Set-ExecutionPolicy Default;
        }
        Catch{
            fnInception 'fnDesactivarEjecucionScripts' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{  
            Remove-Variable vChoice;
        };        
    };
    write-host "`n`t== Proceso terminado ==" -ForegroundColor Green;    
    Write-host "";
    fnPressEnter;
};
function fnDesinstalarOneDrive(){
#Desactivarlo del inicio auto, desinstalar no conseguido.

};
function fnDescargarFichero(){
#Imcompleto
    fnAddToLog "Llegada a fnDescargarFichero";    
    $oWebRequest=New-Object System.Net.WebClient;
    $oWebRequest.DownloadFile("www.adobe.com/archivo.exe","$env:temp" + "\" + "archivo.exe");

    
};
function fnInstalarAdobe(){ #Repasar!!!
#Version futura: Que llame a fnDescargar y luego instale
#Versión actual: Descargue la version hardcodeada a Temp e instale
    fnAddToLog "Llegada a fnInstalarAdobe"; 
    $oListFiles=@{
        "Adobe\Adobe.exe"="/sAll /rs"};
    $aFiles=@("Adobe\Adobe.exe","/sAll /rs");    
    $vPathFTP="ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/1901220036/";
    $vPathFTPyFile="ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/1901220036/AcroRdrDC1901220036_es_ES.exe";
    $vTemp=$env:temp;
    $vTempAndFile="$env:temp" + "\" + "AdobeReaderDC.exe";
    fnEncabezado "Instalar AdobeReaderDC" 2;
    Write-host "`tLa ejecución de este comando descarga del ftp de Adobe e instala AdobeReaderDC en su sistema.";
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    if ($vChoice -eq "s"){
        Write-Host "`n`tPor favor espere a que la descarga se complete...alrededor de 5 minutos.....menos de 10 minutos seguro.....mas o menos... ^_^'";
        Try{#test path to ftp??
           # $client = new-object System.Net.WebClient;$client.DownloadFile("$vPathFTPyFile","$vTempAndFile"); #Metodo con POO            
            Invoke-WebRequest -Uri "$vPathFTPyFile" -OutFile "$vTempAndFile";
            if($?){
                    Write-Host "`tDescarga completada, espere mientras se instala el programa";
                    Start-Process -FilePath "$vTempAndFile" -ArgumentList "$aFiles[1]" -Wait;if($?){Write-Host "`tAdobe => Instalado correctamente"}else{Write-Host "`tAdobe => Error Instalación"};
                    Remove-Item -Path "$vTempAndFile" -Force;If($?){Write-Host "`tAdobe => Borrado ejecutable de %temp%"};
            };
        }
        Catch{
            fnInception 'InstalarAdobe' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{
            Remove-Variable vPathFTP, vChoice, vPathFTPyFile, vTempAndFile, vTemp;
            #$oListFiles.Remove();$aFiles.Remove(); #Error: no se encuentra sobrecarga para remove y el número de argumentos 0
        };
    }; 
    write-host "`n`t== Proceso terminado ==" -ForegroundColor Green;
    write-host "";
    fnPressEnter;
};
function fnInstalarTeamViewer(){
};
function fnCopiarTeamViewer(){
#Copia TV a la carpeta C:\Users\Public\Downloads y crea acceso directo en C:\Users\Public\Desktop
    fnAddToLog "Llegada a fnCopiarTeamViewer";
    #$vPathSource="C:\Users\ituser\Downloads\bb\TeamViewer\TeamViewerQS.exe";
    $vPathSource="\\X.X.X.X\Public\TeamViewer\TeamViewerQS.exe";
    $vItem="";
    $vTemp=$env:temp;
    $vPathDestinyExe="C:\Users\Public\Downloads";
    $vPathDestinyLink="C:\Users\Public\Desktop";
    fnEncabezado "Copiar TeamViewerQS 12" 2;
    Write-host "`tLa ejecución de este comando Copiará TeamViewerQS 12 en su sistema.";
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    if ($vChoice -eq "s"){
        Write-Host "`n`tPor favor espere...";
        Try{
            if ((Test-Path $vPathSource) -and (Test-Path $vPathDestinyExe)){
                Copy-Item -LiteralPath $vPathSource  -Destination "$vPathDestinyExe" -Force;
                $vPathDestinyExe=$vPathDestinyExe + "\" + "TeamViewerQS.exe";
                New-Item -ItemType SymbolicLink -Path "$vPathDestinyLink" -Name "TeamviewerQS 12" -Value "$vPathDestinyExe" -Force;                                                
            }
            Else{
                Write-Host "`n`tError al localizar archivo $vPathSource o vPathDestinyExe" -BackgroundColor Red;
                };
            
        }
        Catch{
            fnInception 'fnCopiarTeamViewer' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{#Confirmar si la variable existe antes de borrar.  
            Remove-Variable vPathSource, vItem, vChoice, vTemp,vPathDestinyExe,vPathDestinyLink;
        };        
    }
    write-host "`n`t== Proceso terminado ==" -ForegroundColor Green;
    write-host "";
    fnPressEnter
};
function fnInstalarBB(){
#Instalar desde MSI o EXE y luego actualizar exe&dll´s
    fnAddToLog "Llegada a fnInstalarBB";
    $aFiles=@("FilesDigitalBook.zip","InstallersDigitalBook.zip");    
    $vPath="C:\Users\ituser\Downloads\bb\";
    $vPath="\\X.X.X.X\Public\Digital Book\";
    $vItem="";
    $vTemp=$env:temp;
    $vRutaInstalacionLocal="C:\Program Files (x86)\ Books\ Digital\";
    fnEncabezado "Instalar BB" 2;
    Write-host "`tLa ejecución de este comando instalará BB en su sistema.";
    Write-Host "Es importante remarcar que por problemas con la opcion desatendida (/q) aparecerá el asistente de instalación" -BackgroundColor Cyan;
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    if ($vChoice -eq "s"){
        Write-Host "`n`tPor favor espere..."; 
        Try {
            ForEach ($vItem in $aFiles){
                $vFullFilePath="$vPath" + "$vItem";
                if (Test-Path $vFullFilePath){
                Copy-Item -Path "$vFullFilePath" -Destination "$vTemp" -Force;
                                
            }
                Else{
                Write-Host "`n`tError al localizar archivo $vFullFilePath" -BackgroundColor Red;
                };
            }
            $vFullFilePath="$vTemp" + "\" + $aFiles[1];       
           Expand-Archive -LiteralPath "$vFullFilePath" $vTemp -Force;
                if($?){
                    Remove-Item -LiteralPath $vFullFilePath -Force;
                    #$vFullFilePath="$vTemp" + "\" + "InstallerBook\InstallerBook.msi";
                    #$vFullFilePath="$vTemp" + "\" + "InstallersDigitalBook\InstallerBook.exe";
                    $vFullFilePath="$vTemp" + "\" + "InstallerBook.exe";
                    #Ambos comandos instala en C:\APPDIR
                    #Install-Package -Name "$vFullFilePath" -Force;
                    #Start-Process -FilePath $vFullFilePath -ArgumentList /q;
                    Start-Process -FilePath $vFullFilePath -Wait;
                    if($?){
                        $vFullFilePath="$vTemp" + "\" + "InstallersDigitalBook";
                        #Remove-Item -LiteralPath $vFullFilePath -Force -Recurse; #No es util porque los archivos los descomprimo directamente en temp, sueltos.
                        $vFullFilePath="$vTemp" + "\" + $aFiles[0];
                        Expand-Archive -LiteralPath "$vFullFilePath" "$vRutaInstalacionLocal" -Force;
                        if($?){
                            Remove-Item -LiteralPath $vFullFilePath -Force;
                            $vRutaInstalacionLocal=$vRutaInstalacionLocal + "Books";
                            #Por si al instalar se genera una carpeta dentro de Books erronea (Bug conocido que cuelga DBK)
                            Get-ChildItem $vRutaInstalacionLocal | Remove-Item -Recurse -Force;
                            if($?){
                            }
                            else{
                                Write-Host "`n`tError al Borrar restos en carpeta Books" -BackgroundColor Red;
                            } 
                        }
                        else{
                            Write-Host "`n`tError al aplicar actualización" -BackgroundColor Red;
                        }                        
                    }
                    else{
                        Write-Host "`n`tError al Instalar archivo $aFiles[0]" -BackgroundColor Red;
                    }                    
                }
                else{
                    Write-Host "`n`tError al descomprimir archivo $aFiles[1]" -BackgroundColor Red;}
        }
        Catch{
            fnInception 'fnInstalarBB' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{#Confirmar si la variable existe antes de borrar.  
            Remove-Variable vPath, vItem, vChoice, vFullFilePath, vTemp, vRutaInstalacionLocal;
            $aFiles.Clear();
        };        
    };
    write-host "`n`t== Proceso terminado ==" -ForegroundColor Green;
    write-host "";
    fnPressEnter
};

function fnCopiarInstalablesDeIntranet(){
    fnAddToLog "Llegada a fnCopiarInstalablesDeIntranet";    
    $vPath="C:\Users\ituser\Downloads\";
    $vPath="\\X.X.X.X\Public\00LapCheck\";
    $oListFiles=@{
        "CCleaner\ccsetup568.exe"="/S"
        "Java\jre-8u261-windows-x64.exe"="/s"
        "Power Point Viewer 2010\PowerPointViewer2010.exe"="/quiet"
        "Thunderbird\Thunderbird Setup 68.10.0.exe"="/S"
        "VLC\vlc-3.0.11-win32.exe"="/S"
        "Global VPN Client\GVC 5.0.0.1120\64-bit GVCSetup 5.0.0.1120.msi"="/Q"
        "Chrome\ChromeStandaloneSetup64.exe"="/silent /install"
        "Firefox\Firefox Setup 78.0.2.exe"="/S"};
    $vFullFilePath="";
    $vKey="";
    $vTemp=$env:temp;
    $vLocalFullFilePath="";
    fnEncabezado "Instalar Programas .EXE" 2;
    Write-host "`tLa ejecución de este comando instalará una serie de programas nuevos en su sistema.";
    Write-host "`t(Ccleaner, Java, PowerPointViewer, Thunderbird, VLC, Global VPN, Chrome, Firefox)";
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    if ($vChoice -eq "s"){
        Try{        
            Write-Host "`n`tProcesando orden..."; 
            foreach ($vKey in $oListFiles.keys){
               $vFullFilePath="$vPath" + "$vKey";
               #$vLocalFullFilePath="$vTemp" + "\" + "$vKey";s
               $vLocalFullFilePath="$vTemp" + "\" + (Split-Path "$vKey" -Leaf);
               #Si no existe el programa en la ruta tendremos una excepción, ¿se puede poner timeout a Test-Path?.
               if (Test-Path $vFullFilePath){
                    Write-Host "`n`tCopiando instalable $vKey a carpeta %temp% local";
                    #Copy-Item -Path "$vFullFilePath" -Destination "$vLocalFullFilePath" -Recurse -Force;
                    Copy-Item -Path "$vFullFilePath" -Destination "$vTemp" -Force;
                    Write-Host "`tInstalando $vKey, por favor espere...";
                    Start-Process -FilePath "$vLocalFullFilePath" -ArgumentList $oListFiles[$vKey] -Wait;If($?){Write-Host "`t$vKey => Instalado correctamente"};
                    Remove-Item -Path "$vLocalFullFilePath" -Force;If($?){Write-Host "`t$vKey => Borrado ejecutable de %temp%"};                    
                    #Start-Process -FilePath "$vFullFilePath" -ArgumentList $oListFiles[$vKey] -Wait;If($?){Write-Host "`n`tInstalado $vKey"};
               }Else{
                   Write-Host "`n`tError al conectarse a $vFullFilePath pasando al siguiente programa";
               };               
            }
        }
        Catch{
            fnInception 'fnCopiarInstalablesDeIntranet' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{#Confirmar si la variable existe antes de borrar. ¿borrar arrays o tablas hash?  
            Remove-Variable vPath, vKey, vChoice, vFullFilePath, vLocalFullFilePath, vTemp;
            $oListFiles.clear();
        };        
    }; 
    write-host "`n`t== Proceso terminado ==" -ForegroundColor Green;
    write-host "";
    fnPressEnter;
};
function fnInstalarProg(){
#Comprobar si ya está instalado?,  y si es versión de 32bits?, Ping a recurso compartido?, y si hay varios .msi misma carpeta?
    fnAddToLog "Llegada a fnInstalarProg";    
    $vPath="C:\Users\ituser\Downloads";
    $vPath="\\X.X.X.X\Public\00LapCheck";
    $vListFiles="";
    $vItem="";
    fnEncabezado "Instalar Programas Checking-List" 2;
    Write-host "`tLa ejecución de este comando instalar una serie de programas nuevos en su sistema.";
    Write-host "`t(Libre Office, 7zip, Pdf Xchange viewer)";
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    if ($vChoice -eq "s"){
        Write-Host "`n`tListando ficheros .msi de la ruta $vPath";
        Write-Host "`n`tPor favor espere..."; 
        Try {
            if (Test-Path $vPath){
                #-Include no respeta el limite de niveles conf con depth
                #$vListFiles=Get-ChildItem -Path "$vPath" -Include *.msi -Recurse;
                #install-package no lo coge bien, hay que retocar vItem de forEach para que coga la ruta completa
                $vListFiles=Get-ChildItem  -Filter *.msi -Depth 1 -Path "$vPath";
                #Solo obtengo el nombre sin ruta, ¿tengo carpeta contenedora del msi?
                #$vListFiles=Get-ChildItem  -name *.msi -Depth 1 -Path "$vPath";
                ForEach ($vItem in $vListFiles) {
                    Write-host "`n`tInstalando $vItem";
                    Install-Package -Name $vItem.FullName -Force;If($?){Write-Host "`tInstalado $vItem" -ForeGround DarkYellow}Else{Write-Host "`tError Instalando $vItem`t" -ForeGround DarkRed -BackgroundColor Gray};
                }
            }
            Else{
                Write-Host "`n`tError al listar la ruta de instalación" -BackgroundColor Red;
            };
           
        }
        Catch{
            fnInception 'fnInstalarProg' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{#Confirmar si la variable existe antes de borrar.  
            Remove-Variable vPath, vListFiles, vItem, vChoice;
        };        
    };
    write-host "`n`t== Proceso terminado ==" -ForegroundColor Green;
    write-host "";
    fnPressEnter;
};
function fnActivarCaracteristicas(){
    fnAddToLog("Llegada a fnActivarCaracteristicas");
    fnEncabezado "Activar características opcionales" 2;
    Write-host "`tLa ejecución de este comando Activará/instalará características opcionales";
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    if ($vChoice -eq "s"){
        Try{#Añadir gestion de error para mostrar mensaje de instalación OK
            Write-Host "`n`tInstalando SSH server";
        #Server SSH para conexión remota
            dism /online /add-capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0 /NoRestart /Quiet;
        #Net Framework 3.5
            Write-Host "`tInstalando .Net3.5 Framework";
            dism /online /enable-feature /Featurename:Netfx3 /all /NoRestart /Quiet;
        #Compatibilidad de Acceso a ficheros sistemas linux
            Write-Host "`tInstalando Compatibilidad NFS Sistemas Linux";
            dism /online /enable-feature /FeatureName:ServicesForNFS-ClientOnly /all /NoRestart /Quiet;
            dism /online /enable-feature /FeatureName:ClientForNFS-Infrastructure /all /NoRestart /Quiet;                
        #Para poder unirse Dom 2k3
            Write-Host "`tInstalando SMB1_Protocol for Legacy Domains";
            dism /online /enable-feature /FeatureName:SMB1Protocol /all /NoRestart /Quiet;
            dism /online /enable-feature /FeatureName:SMB1Protocol-Client /all /NoRestart /Quiet;
        #Finalizando;
            Write-Host "`n`tReinicie para aplicar cambios`t" -BackgroundColor DarkYellow -ForegroundColor Black;
        }
        Catch{
            fnInception 'fnActivarCaracteristicas' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{#Confirmar si la variable existe antes de borrar.   
            Remove-Variable vChoice;
        };
    };
    write-host "`n`t== Proceso terminado ==" -ForegroundColor Green;
    write-host "";
    fnPressEnter;
};
function fnDesinstalarAppPreinstaladas(){
    fnAddToLog "Llegada a fnDesinstalarAppPreinstaladas";
    #$aAppList=@("Microsoft.XboxSpeechToTextOverlay","Microsoft.Xbox.TCUI","Microsoft.MicrosoftOfficeHub","Microsoft.XboxIdentityProvider","Microsoft.ZuneMusic","Microsoft.ZuneVideo","Microsoft.XboxGamingOverlay","Microsoft.XboxGameOverlay","Microsoft.XboxApp","Microsoft.WindowsMaps","Microsoft.People","Microsoft.OneConnect","Microsoft.Office.OneNote","Microsoft.MixedReality.Portal","Microsoft.MicrosoftSolitaireCollection","Microsoft.Microsoft3DViewer","Microsoft.BingWeather","Microsoft.Print3D","Microsoft.WindowsFeedbackHub","Microsoft.Getstarted","king.com.CandyCrushSaga","king.com.CandyCrushFriends","king.com.BubbleWitch3Saga","king.com.CandyCrushSodaSaga");
        
    $aAppList=@("Microsoft.OneConnect","Microsoft.Print3D","king.com.CandyCrushSaga","king.com.CandyCrushFriends","king.com.BubbleWitch3Saga","king.com.CandyCrushSodaSaga");
    $vItem="";
    fnEncabezado "Desinstalar Aplicaciones Preinstaladas" 2;
    Write-host "`tLa ejecución de este comando Desinstalará una serie de App´s Preinstaladas.";
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    if ($vChoice -eq "s"){
        Try{
        write-host "`n`tEjecución en progreso.....";
        Foreach ($vItem in $aAppList) {
            Write-Host "`tEliminando $vItem";
            Get-AppxPackage $vItem | Remove-AppxPackage -AllUsers;
            #Evita que se descargue a los nuevos usuarios
            Get-AppxProvisionedPackage -Online | where {$_.PackageName -like $vItem} | Remove-AppxProvisionedPackage -Online;# -ErrorAction Ignore;
            };
        }
        Catch{
            fnInception 'fnDesinstalarAppPreinstaladas' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{#Confirmar si la variable existe antes de borrar.   
            Remove-Variable aAppList, vItem, vChoice;
        }; 
    };    
    write-host "`n`t== Proceso terminado ==`n" -ForegroundColor Green;
    fnPressEnter;
};
function fnNoDescarguesAplicacionesRecomendadas(){
    fnAddToLog("Llegada a fnNoDescarguesAplicacionesRecomendadas"); 
    $vBin=0;
    $vRegPath="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager";
    #Apps que M$ cambia de nombre para dificultar su desactivación.
    $vMetamorfo="";
    fnEncabezado "Desactivar descarga inicial de Juegos y App´s recomendadas" 2;    
    Write-host "`tLa ejecución de este comando evitará la instalación automatica de App´s varias en ESTE USUARIO";
    $vChoice=fnDameDato "`n`t¿Desea continuar? S/N";
    #Filtro las propiedades con la palabra "Subscribed" en la clave del registro que me interesa.
    $vMetamorfo=Get-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" | Select-Object -ExpandProperty Property | Select-String -Pattern Subscribed;
    if ($vChoice -eq "s"){
        Try{
            Set-ItemProperty "$vRegPath" "ContentDeliveryAllowed" $vBin;
            Set-ItemProperty "$vRegPath" "FeatureManagementEnabled" $vBin;
            Set-ItemProperty "$vRegPath" "OemPreInstalledAppsEnabled" $vBin;
            Set-ItemProperty "$vRegPath" "PreInstalledAppsEnabled" $vBin;
            Set-ItemProperty "$vRegPath" "PreInstalledAppsEverEnabled" $vBin;
            Set-ItemProperty "$vRegPath" "SilentInstalledAppsEnabled" $vBin;
            Set-ItemProperty "$vRegPath" "SoftLandingEnabled" $vBin;
            $vMetamorfo.ForEach({Set-ItemProperty "$vRegPath" "$_" "$vBin"});
            Set-ItemProperty "$vRegPath" "SystemPaneSuggestionsEnabled" $vBin;
            Set-ItemProperty "$vRegPath" "ContentDeliveryAllowed" $vBin;
            Set-ItemProperty "$vRegPath" "ContentDeliveryAllowed" $vBin;
            Write-host "`n`t== Cambio realizado ==" -ForegroundColor Green;
        }        
        Catch{
            fnInception 'fnNoDescarguesAplicacionesRecomendadas' "`t$($_.Exception.GetType().FullName)";
        }
        Finally{#Confirmar si la variable existe antes de borrar.   
            Remove-Variable vBin, vRegPath, vMetamorfo, vChoice;
        }; 
    };
    Write-host "`n";
    fnPressEnter;
};
function fnCrearLog(){
    $vPath=$env:temp + "\" + "Log_Script_Instalacion_Powershell.txt"
        add-content -path $vPath "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
        add-content -path $vPath "Fichero Log para Script_Instalacion_Powershell";
        add-content -path $vPath "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
};
function fnAddToLog($p01){
    $vPath=$env:temp + "\" + "Log_Script_Instalacion_Powershell.txt";
    $vHora=get-date -format g;
    $vMensaje=$vHora + " ==> " + $p01;
    if (!(Test-Path $vPath)){
        fnCrearLog;
    };    
    add-content -path $vPath $vMensaje;
};
function fnDeco01(){
    write-host "`t#############################################" -ForegroundColor DarkGreen;
};
function fnDeco02(){
    write-host "`t---------------------------------------------" -ForegroundColor DarkGreen;
};
function fnEncabezado($pTexto, $pTipoTitulo){   
    Switch ($pTipoTitulo) {
        1{
        Set-Alias -name fCall -value fnDeco01;
        }
        2{
        Set-Alias -name fCall -value fnDeco02;
        }
        3{
        Set-Alias -name fCall -value fnDeco03;
        } 
        default{
        Set-Alias -name fCall -value fnDeco02;
        }  
  };
    Clear-host;
    fCall;
    Write-Host "`t$pTexto";
    fCall;
    Write-Host "";
};;
<#function fnDameDatoSimple(){
    fnAddToLog("Llegada a fnDameDato");
    $vMensaje="Escribe el dato solicitado y pulsa Intro";
    read-host "`t$vMensaje";
};#>
function fnDameDato(){
    Param(
        [string]$pMensaje
    )
    fnAddToLog("Llegada a fnDameDato");
    if ($pMensaje -eq ""){
        $vMensaje="Escribe el dato solicitado y pulsa Intro";
        }Else{
        $vMensaje=$pMensaje;
    };    
    read-host "`t$vMensaje";
};
function fnDespedida(){
    fnAddToLog("Llegada a fnDespedida");Clear-Host;fnDeco01;Write-Host "`t`t`tAdioooooos!!";fnDeco01;
};
function fnPressEnter(){
    [void](Read-Host "`tPress Enter to continue");
};
Function fnInception($p01,$p02){
            Write-Host "`n`t @@@@@ Error :: Excepción no controlada :: @@@@`t" -BackgroundColor Red;
            Write-Host "`t$p02";
            Write-Host "`t @@@@@ Error :: Excepción no controlada :: @@@@`t" -BackgroundColor Red;
            fnAddToLog "Excepción en $p01::$p02"
};
function fnTools(){
    fnAddToLog("Llegada a fnTools")
    $vSentry=0;
    $vDato="";   
    While ($vSentry -ne 10) { 
    fnEncabezado "Herramientas" 2;
    Write-Host "    7) Mostrar los últimos registros del LOG
    8) About this Script
    9) Mostrar la ayuda sobre el menú inicial
    10) Volver`n"
    $vDato=fnDameDato "Escribe el número de la opción a ejecutar";        
        Switch ($vDato) {
            7 {fnMostrarLog;}
            8 {fnAbout;}
            9 {fnHelp;}
            10 {Write-Host "`n`tHas elegido Volver";$vSentry=$vDato;}
            default {Write-Host "`n`tOpción erronea, vuelve a probar";Start-Sleep -Seconds 1;}
        }
        Start-Sleep -Seconds 1;
    };
};
function fnMostrarMenuInicial(){
    fnAddToLog("Llegada a fnMostrarMenuInicial");
    fnEncabezado "Script de Inicio // $vVersionActual" 1;
    Write-Host "    1) Desactivar descarga inicial de Juegos y App´s recomendadas
    2) Desinstalar Aplicaciones Preinstaladas
    3) Activar NFS (NAS Unix) & SMB-1 (Unirse Dominio) & SSH Server & .Net3.5
    4) Instalar Programas .MSI del Checking-List // 3 Apps
    5) Instalar Programas .exe del Checking-List // 8 Apps
    6) Instalar BB y Act a V 2.1.9
    7) Copiar TeamViewerQS 12
    8) Instalar Adobe Reader DC (Función no definitiva)
    9) Desactivar la Ejecución de Scripts
    10) Herramientas
    11) Salir`n";
};
function fnInit(){
    fnCrearLog;
    fnAddToLog("Llegada a fnInit");
    $vSentry=0;
    $vDato="";   
    While ($vSentry -ne 11) {
        fnMostrarMenuInicial;
        $vDato=fnDameDato "Escribe el número de la opción a ejecutar";        
        Switch ($vDato) {
            1 {fnNoDescarguesAplicacionesRecomendadas;}
            2 {fnDesinstalarAppPreinstaladas}
            3 {fnActivarCaracteristicas;}
            4 {fnInstalarProg;}
            5 {fnCopiarInstalablesDeIntranet;}
            6 {fnInstalarBB;}
            7 {fnCopiarTeamViewer;}
            8 {fnInstalarAdobe;}
            9 {fnDesactivarEjecucionScripts;}
            10 {fnTools;}
            11{Write-Host "`n`tHas elegido salir";$vSentry=$vDato;}
            default {Write-Host "`n`tOpción erronea, vuelve a probar";Start-Sleep -Seconds 1;}
        }
        Start-Sleep -Seconds 0.5;
     }
    fnDespedida;    
};
fnInit;