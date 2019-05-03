#!/bin/bash
#
#Elaborado por Arelis_xzx
#///
#Declaracion de variables
campo1IFS=IFS
rango=`date +'%Y-%m-%d'` #Rango de fechas para generar el reporte
passzip='0912isd091·$=)%(1lssjaASDA' #Contraseña de archivo zip, recomiendo encriptarla o alguna tecnica mejor para generarla
chh=`date +'%Y%m%d-%H%M%S'` #Fecha actual
FILE="/tmp/message"$chh".csv" #Directorio y nombre del archivo temporal CVS asegurate de tener espacio de almacenamiento
IFS="`echo -e "\t\n\r\f"`" #Variable para limpiar la lectura de la base de datos
mailto="arelis.mex@gmail.com" #Destinatario del reporte
declare -a IPS #Arreglo que contendra nuestro resultado de la consulta SQL
#Variable con nuestra consulta
#OJO....es importante que administres desde la consulta los campos nullos, ejemplo; ifnull(IF(campo1='' or campo1=NULL,'NA',campo1),'NA'), 
#ya que si no lo haces el reporte saldra mal
SQL="SET CHARACTER SET utf8;select id as 'ID', ifnull(IF(campo1='' or campo1=NULL,'NA',campo1),'NA') as 'Campo 1' , ifnull(IF(campo2='' or campo2=NULL,'NA',campo2),'NA') as 'Campo 2', ifnull(IF(campo3='','NA',campo3),'NA') as 'Campo 3', fecha as 'Fecha' from tubasededatos.tutabladereporte where fecha like '%$rango%'"
#Realizamos la coneccion a la base de datos y le inyectamos nuestra consulta para obtener el resultado y llenar el arreglo
#para usar certificados SSL que es la mejor opcion y en ambientes de nube se utiliza mucho usa:
#IPS=(`echo "$SQL" | mysql --ssl-ca=server-ca.pem --ssl-cert=client-cert.pem --ssl-key=client-key.pem  --host=127.0.0.1 --user=miusuariosql --password='password' --skip-column-names`)
#Si no cuentas co ello usa:
#IPS=(`echo "$SQL" | mysql --host=127.0.0.1 --user=miusuariosql --password='password' --skip-column-names`)
IPS=(`echo "$SQL" | mysql --ssl-ca=server-ca.pem --ssl-cert=client-cert.pem --ssl-key=client-key.pem  --host=127.0.0.1 --user=miusuariosql --password='password' --skip-column-names`)
#Procesamos la informacion del arreglo
COLUMNS=9
ROWS=$[${#IPS[@]} / $COLUMNS]
#informacion General
echo "TOTAL DE ELEMENTOS: "${#IPS[@]}
echo "COLUMNAS: "$COLUMNS
echo "FILAS: "$ROWS
#Limpiamos el archivo para ingresar datos nuevos
echo '' > $FILE
#Ingresamos los datos al Archivo
echo "ID;Mi Campo1;Mi Campo 2;Mi Campo3;Fecha" > $FILE #Esta es la primera fila de tu archivo contiene el nombre de cada columna
for (( i=0; i<$ROWS; i++ ));
do
        for (( j=0; j<$COLUMNS; j++ ));
        do
                ELEM=$[$i * $COLUMNS + $j]
                echo -n "${IPS[$ELEM]}" ";" >> $FILE
        done
        echo -e "\n" >> $FILE
done
#Fin de ingreso de info al archivo
IFS=campo1IFS
#Fin de proceso de informacion 
#Comprimimos el archivo con la info y agregamos password
zip -P $passzip $FILE".zip" $FILE
rm -f $FILE #Borramos el archivo tmp opcional
rm -g $FILE".zip" #Borramos el archivo zip opcional
#Enviamos por correo 
echo "" | mutt -s "Asunto de correo:" $mailto -a $FILE
