



	CREATE PROC [dbo].[sp_Inserta_CD4_SisLab]
		@id_TxCD4 int

	as

	BEGIN  

		SET NOCOUNT ON
		SET XACT_ABORT ON

		BEGIN TRY
			--BEGIN TRANSACTION

				Declare @CodMuestra varchar(50)
				Declare @CodMuestraSiLabResultados varchar(50)

				Declare @CD4 varchar(50)
				Declare @CD8 varchar(50)
				Declare @CD3 varchar(50)
				Declare @Ratio varchar(50)
				Declare @CD4_PC varchar(50)
				Declare @CD8_PC varchar(50)

				Declare @IdPruebaSolicitada int 

				set @CodMuestra = (select top 1 SampleID FROM Tx_CD4 Where Estado = 0 and Id_Tx_CD4 = @id_TxCD4 Order by ExportDate Desc)
				set @CodMuestraSiLabResultados = (select top 1 A.Codigo_Muestra from Resultados A Where Id_Prueba = 44 and Codigo_Muestra in (@CodMuestra))
				
				set @CD3 = (select top 1 CD3_AbsCnt FROM Tx_CD4 Where Estado = 0 and Id_Tx_CD4 = @id_TxCD4 Order by ExportDate Desc)
				
				set @CD4 = (select top 1 CD3_CD4_AbsCnt_excl FROM Tx_CD4 Where Estado = 0 and Id_Tx_CD4 = @id_TxCD4 Order by ExportDate Desc)
				set @CD4_PC = (select top 1 convert(varchar,Cast(CD3_CD4_Lymphs_excl_p As decimal(18,2))) FROM Tx_CD4 Where Estado = 0 and Id_Tx_CD4 = @id_TxCD4 Order by ExportDate Desc)
				
				set @CD8 = (select top 1 CD3_CD8_AbsCnt_excl FROM Tx_CD4 Where Estado = 0 and Id_Tx_CD4 = @id_TxCD4 Order by ExportDate Desc)
				set @CD8_PC = (select top 1 convert(varchar,Cast(CD3_CD8_Lymphs_excl_p As decimal(18,2))) FROM Tx_CD4 Where Estado = 0 and Id_Tx_CD4 = @id_TxCD4 Order by ExportDate Desc)
				
				set @Ratio = (select top 1 Ratio FROM Tx_CD4 Where Estado = 0 and Id_Tx_CD4 = @id_TxCD4 Order by ExportDate Desc)
				
				
				set @IdPruebaSolicitada = (select top 1 A.Id_Prueba_Solicitada from Recepcion_Muestra A
											left join Prueba_Solicitada B On B.Id_Prueba_Solicitada = A.Id_Prueba_Solicitada
											left join Muestra_Prueba C On C.Id_Muestra_Prueba = B.Id_MuestraPrueba
											where C.Id_Prueba = 44 and A.Muestra_Recibida = 1 and A.Id_Estatus_Muestra = 1 and A.Codigo_Muestra in (@CodMuestra) )



		IF (@IdPruebaSolicitada is not null)
			Begin
				IF (@CodMuestra is not null)
					Begin
						IF (@CodMuestraSiLabResultados is null)
							Begin
								Begin
									INSERT INTO [Resultados]
										   ([Codigo_Muestra]
										   ,[Id_Prueba_Solicitada]
										   ,[Id_Prueba]
										   ,[Id_Linea_Resultado]
										   ,[Resultado]
										   ,[Usuario]
										   ,[Resultado2]
										   ,[Resultado3])
									 VALUES
										   (@CodMuestra
										   ,@IdPruebaSolicitada
										   ,44
										   ,38--CD4    --39--CD8   ,40--CD3    ,41--Ratio   ,42--%CD4   ,43--%CD8
										   ,@CD4
										   ,'laboratoriocd4'
										   ,null
										   ,null)
								End
								Begin
									INSERT INTO [Resultados]
										   ([Codigo_Muestra]
										   ,[Id_Prueba_Solicitada]
										   ,[Id_Prueba]
										   ,[Id_Linea_Resultado]
										   ,[Resultado]
										   ,[Usuario]
										   ,[Resultado2]
										   ,[Resultado3])
									 VALUES
										   (@CodMuestra
										   ,@IdPruebaSolicitada
										   ,44
										   ,39--CD8
										   ,@CD8
										   ,'laboratoriocd4'
										   ,null
										   ,null)
								End
								Begin
									INSERT INTO [Resultados]
										   ([Codigo_Muestra]
										   ,[Id_Prueba_Solicitada]
										   ,[Id_Prueba]
										   ,[Id_Linea_Resultado]
										   ,[Resultado]
										   ,[Usuario]
										   ,[Resultado2]
										   ,[Resultado3])
									 VALUES
										   (@CodMuestra
										   ,@IdPruebaSolicitada
										   ,44
										   ,40--CD3
										   ,@CD3
										   ,'laboratoriocd4'
										   ,null
										   ,null)
								End
								Begin
									INSERT INTO [Resultados]
										   ([Codigo_Muestra]
										   ,[Id_Prueba_Solicitada]
										   ,[Id_Prueba]
										   ,[Id_Linea_Resultado]
										   ,[Resultado]
										   ,[Usuario]
										   ,[Resultado2]
										   ,[Resultado3])
									 VALUES
										   (@CodMuestra
										   ,@IdPruebaSolicitada
										   ,44
										   ,41--Ratio
										   ,@Ratio
										   ,'laboratoriocd4'
										   ,null
										   ,null)
								End
								Begin
									INSERT INTO [Resultados]
										   ([Codigo_Muestra]
										   ,[Id_Prueba_Solicitada]
										   ,[Id_Prueba]
										   ,[Id_Linea_Resultado]
										   ,[Resultado]
										   ,[Usuario]
										   ,[Resultado2]
										   ,[Resultado3])
									 VALUES
										   (@CodMuestra
										   ,@IdPruebaSolicitada
										   ,44
										   ,42--%CD4
										   ,@CD4_PC
										   ,'laboratoriocd4'
										   ,null
										   ,null)
								End
								Begin
									INSERT INTO [Resultados]
										   ([Codigo_Muestra]
										   ,[Id_Prueba_Solicitada]
										   ,[Id_Prueba]
										   ,[Id_Linea_Resultado]
										   ,[Resultado]
										   ,[Usuario]
										   ,[Resultado2]
										   ,[Resultado3])
									 VALUES
										   (@CodMuestra
										   ,@IdPruebaSolicitada
										   ,44
										   ,43--%CD8
										   ,@CD8_PC
										   ,'laboratoriocd4'
										   ,null
										   ,null)
								End

								Begin
									Update [Prueba_Solicitada]
									Set [Id_EstatusResultado] = 1
									Where [Id_Prueba_Solicitada] = @IdPruebaSolicitada
								  
								End


								Begin
									UPDATE Tx_CD4
										SET [Estado] = 1
									WHERE Estado = 0 and Id_Tx_CD4 = @id_TxCD4
								End
								Begin
									Select 'True|Resultados ingresados de forma correcta' as Resultado
								End
							End
						Else
							Begin

								Select 'False|Error resultados ya fueron ingresados' as Resultado

							End
					End   
				Else 
					Begin	
						Select 'False|Error resultados sin datos' as Resultado
					End
			End
		Else
			Begin
				Select 'False|Error prueba solicitada sin datos o muestra no recibida' as Resultado
			End

				
			--COMMIT TRANSACTION	
						
		END TRY

		BEGIN CATCH
			
			--ROLLBACK TRANSACTION

			Select 'False|Error en procedimiento - linea: '+convert(varchar,ERROR_LINE())+' - error: ' + convert(varchar,ERROR_MESSAGE())+' - estado: ' + convert(varchar,ERROR_STATE())+' - severidad: ' + convert(varchar,ERROR_SEVERITY())  as Resultado

		END CATCH

	END



GO



