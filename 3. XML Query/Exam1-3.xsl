<!--** 1-1 **-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match = "Department">
        <Title><xsl:value-of select="Title"/> </Title>
    </xsl:template>
</xsl:stylesheet>


<!--** 1-2 **-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">  
    <xsl:template match = "Department">
        <Department>
            <Title><xsl:value-of select="Title"/></Title>
            <xsl:copy-of select="Chair"/> 
        </Department>
    </xsl:template>
    
    <xsl:template match="text()"/>
    
</xsl:stylesheet>


<!--** 2-1 **-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">    
    <xsl:template match = "Course[@Enrollment > 500]">        
        <xsl:copy-of select="."/>         
    </xsl:template>   
    <xsl:template match="text()"/>   
</xsl:stylesheet>



<!--** 2-2 **-->
----------------- :( --------------------
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="*|@*|text()">
       <xsl:copy>
          <xsl:apply-templates select="*|@*|text()" />
       </xsl:copy>
    </xsl:template>
    
    <xsl:template match = "Course[@Enrollment &gt; 60]"/>        
    <xsl:template match = "Course[count(@Enrollment) &lt; 1]"/>  
    
</xsl:stylesheet>


<!--** 2-3 **-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- actually do not need this part-->    
    <xsl:template match="Department[@Code = 'EE']/Course">
       <xsl:copy>
          <xsl:apply-templates select="." />
       </xsl:copy>
    </xsl:template>

<!-- be same with others-->
	<xsl:template match="Department[@Code = 'EE']/Course">
	   <Course Number = '{data(@Number)}' Title = '{Title}'>
	   	<xsl:copy-of select='Description' />
	   	<xsl:for-each select='Instructors/*'>
	    	<Instructor><xsl:value-of select='Last_Name'/></Instructor>
	    </xsl:for-each>
	    </Course>    
	</xsl:template>

	<xsl:template match="text()"/>   
</xsl:stylesheet>

<!--** 2-4 **-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" />

    <xsl:template match="Department[@Code = 'CS']">
    
        <table border = '1'>
        	<!--
        	<th>Number</th>
        	<th>Title</th>
        	<th>Enrollment</th>
        -->
        	<xsl:for-each select = "Course[@Enrollment &gt; 200]">
        	<xsl:sort select = "Title"/>
        		<tr>
        		<td><i><xsl:value-of select="@Number"/></i></td>
        		<td><b><xsl:value-of select="Title"/></b></td>
        		<td><xsl:value-of select="@Enrollment"/></td>
        		</tr>
        	</xsl:for-each>
        </table>
    
    </xsl:template>

    <xsl:template match="text()"/>   
</xsl:stylesheet>

