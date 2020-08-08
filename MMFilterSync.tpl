#TEMPLATE(MMFilterSync,'Templates Filtro para Syncronización NT'),FAMILY('ABC')
#SYSTEM
!-----------------------------------------------------------------------------------------------------
#EXTENSION(MM_FilterSync,'MM: Template Filtro NetTalk'),APPLICATION(MM_FilterSyncLocal(MMFilterSync))
!-----------------------------------------------------------------------------------------------------
#PREPARE
#ENDPREPARE

#SHEET
    #TAB('Global')
        #Display('Template Filtro de Sync')    
        #PROMPT('Deshabilitar el template Global',CHECK),%MMDesactivarGlobal,DEFAULT(%FALSE)
    #ENDTAB
#ENDSHEET
!-----------------------------------------------------------------------------------------------------
#EXTENSION(MM_FilterSyncLocal,'MM: Template Filtro NetTalk Local'),PROCEDURE,FIRST,REQ(MM_FilterSync)
!-----------------------------------------------------------------------------------------------------
#RESTRICT
#FOR(%ActiveTemplate),WHERE(%ActiveTemplate='BrowseBox(ABC)')
    #ACCEPT
#ENDFOR
#REJECT
#ENDRESTRICT

#PREPARE

#ENDPREPARE
#!
#SHEET
    #TAB('Local'),WHERE(%MMDesactivarGlobal=%False)
        #DISPLAY('Template Filtro de Sync Local')    
        #PROMPT('Deshabilitar el template',CHECK),%MMDesactivarLocal,DEFAULT(%FALSE)
    #ENDTAB
#ENDSHEET		
#!
#ATSTART
#DECLARE(%MMBrowseInstance)
#DECLARE(%MMPrimaryFile)
#FOR(%ActiveTemplate),WHERE(%ActiveTemplate='BrowseBox(ABC)')
    #FOR(%ActiveTemplateInstance)
        #SET(%MMBrowseInstance,%ActiveTemplateInstance)
        #FIX(%File,%Primary)
        #SET(%MMPrimaryFile,%File)
    #ENDFOR
#ENDFOR
#ENDAT
#!
#AT(%BrowserMethodCodeSection,%MMBrowseInstance,'ValidateRecord','(),BYTE'),PRIORITY(2500)
#FOR(%File),WHERE(%File=%MMPrimaryFile)
 #FOR(%Field),WHERE(INSTRING('DELETEDTIMESTAMP',UPPER(%Field),1,1))
        IF %Field <> 0 THEN
            RETURN Record:Filtered
        END
  #ENDFOR       
#ENDFOR
      
#ENDAT