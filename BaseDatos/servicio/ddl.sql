



CREATE TABLE [dbo].[Tx_CD4](
	[Id_Tx_CD4] [int] IDENTITY(1,1) NOT NULL,

	[Fecha]		[datetime] NOT NULL,
	[Archivo]	[varchar](200) NOT NULL,

	[SampleID]	[varchar](50) NOT NULL,
	[ExportDate] [datetime] NOT NULL,
	[Worklist] [varchar](100) NOT NULL,

	[LymphsAbsCnt] [int] NULL,
	
	[CD3_Lymphs_p] [float] NULL,
	[CD3_AbsCnt] [int] NULL,
	
	[CD3_CD4_Lymphs_p] [float] NULL,
	[CD3_CD4_AbsCnt] [int] NULL,
	
	[CD3_CD4_Lymphs_excl_p] [float] NULL,
	[CD3_CD4_AbsCnt_excl] [int] NULL,
	
	[CD3_CD8_Lymphs_p] [float] NULL,
	[CD3_CD8_AbsCnt] [int] NULL,
	
	[CD3_CD8_Lymphs_excl_p] [float] NULL,
	[CD3_CD8_AbsCnt_excl] [int] NULL,
	
	[CD3_CD4_CD8_Lymphs_p] [float] NULL,
	[CD3_CD4_CD8_AbsCnt] [int] NULL,
	
	[CD3_CD4-D8-Lymphs_p] [float] NULL,
	[CD3_CD4-CD8-AbsCnt] [int] NULL,

	[Ratio] [float] NULL,

	   

	[Estado] [int] NOT NULL,
	[FechaMod] [datetime] NULL
 CONSTRAINT [PK_Id_Tx_CD4] PRIMARY KEY CLUSTERED 
(
	[Id_Tx_CD4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tx_CD4] ADD  CONSTRAINT [DF_Tx_CD4_Estado]  DEFAULT ((0)) FOR [Estado]
GO


ALTER TABLE [dbo].[Tx_CD4] ADD  CONSTRAINT [DF_Tx_CD4_Fecha]  DEFAULT (CONVERT(DATETIME,SWITCHOFFSET(GETUTCDATE(), '-06:00'))) FOR [Fecha]
GO
