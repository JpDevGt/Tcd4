



	CREATE PROC [dbo].[sp_Eliminar_CD4]
		@id_TxCD4 int
		, @usuario varchar(50)

	as

	BEGIN  

		SET NOCOUNT ON
		SET XACT_ABORT ON

		BEGIN TRY
			--BEGIN TRANSACTION

				Declare @CodMuestra varchar(50)
				
				set @CodMuestra = (select top 1 SampleID FROM Tx_CD4 Where Estado = 0 and Id_Tx_CD4 = @id_TxCD4)
			
				IF (@CodMuestra is not null)
					Begin
						Begin
							UPDATE Tx_CD4
								SET [Estado] = 2
								, [UsuarioMod] = @usuario
								, [FechaMod] = CONVERT(DATETIME,SWITCHOFFSET(GETUTCDATE(), '-06:00'))
							WHERE Id_Tx_CD4 = @id_TxCD4
						End
						Begin
							Select 'True|Resultados eliminados de forma correcta' as Resultado
						End
					End   
				
		
				
			--COMMIT TRANSACTION	
						
		END TRY

		BEGIN CATCH
			
			--ROLLBACK TRANSACTION

			Select 'False|Error en procedimiento - linea: '+convert(varchar,ERROR_LINE())+' - error: ' + convert(varchar,ERROR_MESSAGE())+' - estado: ' + convert(varchar,ERROR_STATE())+' - severidad: ' + convert(varchar,ERROR_SEVERITY())  as Resultado

		END CATCH

	END

GO


