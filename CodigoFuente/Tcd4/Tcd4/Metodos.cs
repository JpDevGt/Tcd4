using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.IO;
using System.Data;
using System.Data.SqlClient;

namespace Tcd4
{
    class Metodos
    {
        
        private SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["conString"].ConnectionString);

       



        public static void validarArchivos()
        {
            string dirOrigen = ConfigurationManager.AppSettings["Origen"].ToString() + "\\" + DateTime.Today.ToString("yyyyMMdd");

            if (Directory.Exists(dirOrigen))
            {
                
                DataTable dt = new DataTable();
                SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["conString"].ConnectionString);

                try
                {
                    
                    string strSQL = String.Format("Select distinct Archivo From Tx_Cd4 where Estado in (0,1) and convert(varchar, Fecha, 23) = '{0}' ", DateTime.Now.ToString("yyyy-MM-dd"));
                    cn.Open();
                    SqlCommand cmd = new SqlCommand(strSQL, cn);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                    cn.Close();
                }
                catch (Exception ex)
                {
                    cn.Close();
                    SetLog("Error", "Error al conectar con SisLab: [ " + ex.Message +" ] ");
                }


                DirectoryInfo directorio = new DirectoryInfo(dirOrigen);
                
                foreach (var fi in directorio.GetFiles("*", SearchOption.AllDirectories))
                {
                    if(!archivoSubido(fi.Name, dt))
                    {
                        Boolean resultado = cargarResultados(dirOrigen, fi.Name, fi.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss"));
                        if (resultado)
                        {
                            moverArchivo(dirOrigen, fi.Name);
                        }
                        else
                        {
                            SetLog("Error", "Resultado no subido");
                        }
                    }
                }


            }
            else
            {
                SetLog("Evento", "Directorio no encontrado");
            }


        }


        private static Boolean moverArchivo(string ruta, string nombre)
        {
            Boolean res = false;
            string pathOrigenArchivo = ruta + "\\" + nombre;
            string pathDestino = ConfigurationManager.AppSettings["Destino"].ToString() + "\\" + DateTime.Today.ToString("yyyyMMdd");



            try
            {
                if (File.Exists(pathOrigenArchivo))
                {
                    if (!Directory.Exists(pathDestino))
                    {
                        Directory.CreateDirectory(pathDestino);
                    }

                    File.Move(pathOrigenArchivo, pathDestino + "\\" + nombre);

                    SetLog("Evento", "Archivo cambio de ubicacion a destino");
                    res = true;
                }
                
                             
            }
            catch (Exception ex)
            {
                SetLog("Error", "Error al mover archivo: " + ex.Message);
            }
            
            return res;
        }

        private static Boolean archivoSubido(String arch, DataTable dt)
        {
            Boolean res = false;
            foreach (DataRow row in dt.Rows)
            {
                if (arch.Equals(row[0].ToString()))
                {
                    res = true;
                    break;
                }
            }

            return res;
        }



        private static Boolean cargarResultados(string ruta, string nombre, string fecha)
        {
            string Tabla = "Tx_CD4";
            string Query = "";
            Boolean res = false;

            string[] filas = File.ReadAllLines(ruta + "\\" + nombre);

            try
            {

                foreach (var linea in filas)
                {
                    string[] separador = new string[] { "\",\"", "\"" };
                    string[] datos = linea.Split(separador, StringSplitOptions.None);

                    if (!datos[1].Equals(ConfigurationManager.AppSettings["Exclusion"].ToString()))
                    {
                        Query = "INSERT INTO " + Tabla + "  "
                           + " ([Fecha] "
                           + " ,[Archivo] "
                           + " ,[SampleID] "
                           + " ,[ExportDate] "
                           + " ,[Worklist] "
                           + " ,[LymphsAbsCnt] "
                           + " ,[CD3_Lymphs_p] "
                           + " ,[CD3_AbsCnt] "
                           + " ,[CD3_CD4_Lymphs_p] "
                           + " ,[CD3_CD4_AbsCnt] "
                           + " ,[CD3_CD4_Lymphs_excl_p] "
                           + " ,[CD3_CD4_AbsCnt_excl] "
                           + " ,[CD3_CD8_Lymphs_p] "
                           + " ,[CD3_CD8_AbsCnt] "
                           + " ,[CD3_CD8_Lymphs_excl_p] "
                           + " ,[CD3_CD8_AbsCnt_excl] "
                           + " ,[CD3_CD4_CD8_Lymphs_p] "
                           + " ,[CD3_CD4_CD8_AbsCnt] "
                           + " ,[CD3_CD4-D8-Lymphs_p] "
                           + " ,[CD3_CD4-CD8-AbsCnt] "
                           + " ,[Ratio]) "

                           + " VALUES "
                           + "( '" + fecha + "'"
                           + ", '" + nombre + "'"
                           + ", '" + datos[1] + "'"
                           + ", '" + datos[3] + "'"
                           + ", '" + datos[8] + "'"
                           + ", " + datos[22]
                           + ", " + datos[23]
                           + ", " + datos[24]
                           + ", " + datos[25]
                           + ", " + datos[26]
                           + ", " + datos[27]
                           + ", " + datos[28]
                           + ", " + datos[29]
                           + ", " + datos[30]
                           + ", " + datos[31]
                           + ", " + datos[32]
                           + ", " + datos[33]
                           + ", " + datos[34]
                           + ", " + datos[35]
                           + ", " + datos[36]
                           + ", " + datos[37]
                           + ")";

                        DataTable dt = new DataTable();
                        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["conString"].ConnectionString);

                        try
                        {

                            string strSQL = String.Format(Query);
                            cn.Open();
                            SqlCommand cmd = new SqlCommand(strSQL, cn);
                            SqlDataAdapter da = new SqlDataAdapter(cmd);
                            da.Fill(dt);
                            cn.Close();

                            SetLog("Evento", "Resultado cargado con exito");
                            res = true;
                        }
                        catch (Exception ex)
                        {
                            cn.Close();
                            res = false;
                            SetLog("Error", "Error al conectar con SisLab: [ " + ex.Message + " ] ");
                        }



                    }









                }
                return res;
            }

            catch (Exception ex)
            {
                SetLog("Error", "Error al cargar archivo: " + ex.Message);
                return res;
            }
        }
        



        public static void SetLog(string encabezado, string mensaje)
        {
            string pathLog = ConfigurationManager.AppSettings["Log"].ToString();

            StreamWriter log;
            FileStream fileStream = null;
            DirectoryInfo logDirInfo = null;
            FileInfo logFileInfo = null;

            string logFilePath = pathLog;

            logFilePath = logFilePath + "\\Log_" + System.DateTime.Today.ToString("yyyy-MM-dd").ToString();
            logFileInfo = new FileInfo(logFilePath);
            logDirInfo = new DirectoryInfo(logFileInfo.DirectoryName);

            if (!logDirInfo.Exists) logDirInfo.Create();

            if (!logFileInfo.Exists)
            {
                fileStream = logFileInfo.Create();
            }
            else
            {
                fileStream = new FileStream(logFilePath, FileMode.Append);
            }

            log = new StreamWriter(fileStream);

            string blanco = "                    ";
            encabezado = string.Concat(encabezado, blanco.Substring(0, 20 - encabezado.Length));

            string strMassage = string.Concat(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), " | ", encabezado, " | ", mensaje);
            log.WriteLine(strMassage);
            log.Close();

        }



    }
}
