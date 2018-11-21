<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="ImprovedShipper.ShippingRequest" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>OAI Shipping Request</title>
    <!-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>-->
    <!--<link href="~/Styles/Site.css" rel="stylesheet" type="text/css" />original css link-->
    <!--This page was refactored to a modernized layout that may display for mobile devices by Dan Engle 10/5/2018 but 
        the tags with "asp" attribute were left-over from exisitng code-->
    <link href="Content/bootstrap.css" rel="stylesheet" />
</head>
<body>
    <div class="container">
    <nav class="navbar navbar-dark bg-dark" style="padding: 0px;">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="https://www.oai.aero/"><img src="images/omni_logo.png" alt="" style="padding: 0px; margin: 0px;"></a>
                <button class="btn btn-sm btn-primary" type="button"><a style="color:azure;" href="Retrieve.aspx">Retrieve request info</a></button>
                <!--<button class="btn btn-sm btn-outline-secondary" type="button"><a href="UpdateInfo.aspx">Modify request info</a></button>-->
            </div>
        </div>
    </nav>
    <div class="header text-center">
        <h4 class="display-5">Shipping Request Form</h4>
    </div>
    <div class="text-center">
        <asp:Label ID="lblValidationSummary" runat="server" Text="" ForeColor="red"></asp:Label><br />
    </div>
    <form class="form" id="form1" runat="server">
    <table class="table table-hover text-center">
        <thead>
            <tr>
                <th>Logged in as:</th>
                <th>
                    <asp:TextBox class="form-control" ID="txtLoggedInUser" runat="server" Enabled="False"></asp:TextBox>
                </th>
            </tr>
            <tr>
                <th>Date:</th>
                <th><asp:TextBox class="form-control" ID="txtTodaysDate" runat="server" AutoPostBack="True" Enabled="False"></asp:TextBox></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th>Purpose (This selection is required):
                <asp:Label ID="PurposeErrLabel" runat="server" Text=""></asp:Label>
                </th>
                <th>
                    <asp:RadioButtonList ID="rblBusinessPrivate" runat="server" RepeatDirection="Horizontal" AutoPostBack="True">
                        <asp:ListItem Value="B"> Business</asp:ListItem>
                        <asp:ListItem Value="P"> Personal</asp:ListItem>
                    </asp:RadioButtonList>                    
                </th>
            </tr>
        </tbody>
    </table>            
    <asp:TextBox ID="txtShipID" runat="server" Visible="false"></asp:TextBox>
    <asp:panel id="Panel2" runat="server" groupingtext="Initiating Department (This selection is required):">
        <asp:DropDownList class="form-control" ID="ddlInitiatingDepartment" runat="server" AutoPostBack="True" onselectedindexchanged="ddlInitiatingDepartment_SelectedIndexChanged"></asp:DropDownList>
        <asp:TextBox ID="txtOtherInitiatingDepartment" runat="server" Visible="False"></asp:TextBox>
        <asp:DropDownList class="form-control" ID="ddlSubDepartments" runat="server" AutoPostBack="True" Visible="False" onselectedindexchanged="ddlSubDepartments_SelectedIndexChanged"></asp:DropDownList>
    </asp:panel>
    <br><br>
    <asp:panel id="Panel3" runat="server" groupingtext="Shipping Information"> 
    <table class="table table-hover text-center">
	    <tr>
		<td><asp:Label ID="Label13" runat="server" Text="From Name (This field is required)"></asp:Label></td>
        <td><asp:TextBox class="form-control" ID="txtFromName" runat="server"></asp:TextBox></td>
        </tr>       
       <tr>
        <td><asp:Label ID="Label3" runat="server" Text="Phone (This field is required)"></asp:Label></td>
        <td><asp:TextBox class="form-control" ID="txtFromPhone" runat="server"></asp:TextBox></td>
        </tr>
         <tr>
        <td><asp:Label ID="Label10" runat="server" Text="Email Address (This field is required)"></asp:Label></td>
        <td><asp:TextBox class="form-control" ID="txtEmailAddress" runat="server"></asp:TextBox></td>
        </tr>
    </table>
    <br>
    <asp:GridView ID="gvClientAddresses" runat="server" OnRowCommand="OnRowCommand" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White"/>
        <Columns> 
            <asp:ButtonField CommandName="ButtonField" ButtonType="Button"/> 
            <asp:boundfield datafield="Shipping_Client_Addresses_ID" headertext="ID" /> 
            <asp:boundfield datafield="Name" headertext="Name"/> 
            <asp:boundfield datafield="Country" headertext="Country"/> 
            <asp:boundfield datafield="Company" headertext="Company"/> 
            <asp:boundfield datafield="AddressOne" headertext="Address One"/>
            <asp:boundfield datafield="AddressTwo" headertext="Address Two"/>
            <asp:boundfield datafield="City" headertext="City"/> 
            <asp:boundfield datafield="State" headertext="State"/> 
            <asp:boundfield datafield="Postal_Code" headertext="Postal Code"/> 
            <asp:boundfield datafield="Phone" headertext="Phone"/>
        </Columns>    
            <EditRowStyle BackColor="#2461BF"/>
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White"/>
            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White"/>
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center"/>
            <RowStyle BackColor="#EFF3FB"/>
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333"/>
            <SortedAscendingCellStyle BackColor="#F5F7FB"/>
            <SortedAscendingHeaderStyle BackColor="#6D95E1"/>
            <SortedDescendingCellStyle BackColor="#E9EBEF"/>
            <SortedDescendingHeaderStyle BackColor="#4870BE"/>
    </asp:GridView>
    <br><br>
    <table>
        <tr>
            <td>
                <asp:Label ID="lblValidationSummaryShipping" runat="server" Text="" ForeColor="red"></asp:Label>
            </td>
        </tr>
    </table>
    <br />
    <div class="wrapper text-center">
        <div class="btn-group" role="group">
            <asp:Button class="btn btn-primary" ID="btnSearch" runat="server" Text="Search" onclick="btnSearch_Click" ToolTip="Search for previously entered shipping addresses."/>      
            <asp:Button class="btn btn-success" ID="btnSave" runat="server" Text="Save" onclick="btnSave_Click" ToolTip="Save new shipping adresses to the database."/>
            <asp:Button class="btn btn-secondary" ID="btnUpdate" runat="server" Text="Update" onclick="btnUpdate_Click" ToolTip="Update current shipping address."/>
            <asp:Button class="btn btn-danger" ID="btnDelete" runat="server" Text="Delete" onclick="btnDelete_Click" ToolTip="Delete current shipping address."/>
            <asp:Button class="btn btn-warning" ID="btnClearShippingFields" runat="server" Text="Clear" ToolTip="Clear shipping address fields." onclick="btnClearShippingFields_Click"/>
        </div>
    </div>
    <br><br>
    <table class="table table-hover text-center">
        <tr>
		    <td><asp:Label ID="Label16" runat="server" Text="Company or Name (This field is required)"></asp:Label></td>
            <td><asp:TextBox class="form-control" ID="txttoCompanyOrNameOrName" runat="server"></asp:TextBox></td>
        </tr>
         <tr>
		    <td><asp:Label ID="Label15" runat="server" Text="Country (This field is required)"></asp:Label></td>
            <td><asp:DropDownList class="form-control" ID="ddlCountries" runat="server" AutoPostBack="True" onselectedindexchanged="ddlCountries_SelectedIndexChanged"></asp:DropDownList>                   
            </td>   
        </tr>
        <tr>
            <td><asp:Label ID="Label6" runat="server" Text="Attn (Required for International)"></asp:Label></td>
            <td><asp:TextBox class="form-control" ID="txtToAttn" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td> <asp:Label ID="Label7" runat="server" Text="Address One (This field is required)"></asp:Label></td>
            <td><asp:TextBox class="form-control" ID="txtToAddressOne" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:Label ID="Label11" runat="server" Text="Address Two"></asp:Label></td>
            <td><asp:TextBox class="form-control" ID="txtToAddressTwo" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td><asp:Label ID="Label2" runat="server" Text="City (This field is required)"></asp:Label></td>
            <td><asp:TextBox class="form-control" ID="txtCity" runat="server"></asp:TextBox></td>
        </tr>
        <tr>      
            <td><asp:Label ID="Label8" runat="server" Text="Political subunit"></asp:Label></td>
            <td>
                <asp:DropDownList class="form-control" ID="ddlStates" runat="server" Enabled="true"></asp:DropDownList>     
            </td>
        </tr>
        <tr>
            <td><asp:Label ID="Label9" runat="server" Text="Postal Code (This field is required)"></asp:Label></td>
            <td><asp:TextBox class="form-control" ID="txtPostalCode" runat="server"></asp:TextBox></td>
        </tr>
	    <tr>
            <td><asp:Label ID="Label5" runat="server" Text="Phone + Extension (This field is required)"></asp:Label></td>
            <td><asp:TextBox class="form-control" ID="txtToPhone" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td>&nbsp</td>
            <td><asp:TextBox ID="txtID" runat="server" Visible="false"></asp:TextBox></td>
        </tr>
    </table>		
    </asp:panel>
    <asp:panel id="Panel5" runat="server" groupingtext="Boxes To Ship (This field is required)">
        <asp:Label ID="Label14" runat="server" Text="Note: If more than one box shipping to one address do you prefer separate AWB #’s or one AWB for all boxes?"></asp:Label>
        <asp:DropDownList class="form-control" ID="ddlNumberItemsShipped" runat="server" AutoPostBack="True" onselectedindexchanged="ddlNumberItemsShipped_SelectedIndexChanged">
            <asp:ListItem>1</asp:ListItem>
            <asp:ListItem>2</asp:ListItem>
            <asp:ListItem>3</asp:ListItem>
            <asp:ListItem>4</asp:ListItem>
            <asp:ListItem>5</asp:ListItem>
            <asp:ListItem>6</asp:ListItem>
        </asp:DropDownList>         
        <br><hr>
        <asp:Label ID="lblDescription" runat="server" Text="Items Being Shipped and "></asp:Label> 
        <asp:Label ID="lblQuantity" runat="server" Text="Quantity for each!"></asp:Label>
        <br><hr>
        <asp:TextBox class="form-control" ID="txtDescriptionOne" runat="server" Visible="False" placeholder="Item one desc (This field is required)"></asp:TextBox>
        <asp:TextBox class="form-control" ID="txtQuantityOne" runat="server" Visible="False" placeholder="Item one qty (This field is required)"></asp:TextBox>
        
        <asp:TextBox class="form-control" ID="txtDescriptionTwo" runat="server" Visible="False" placeholder="Item two desc (This field is required)"></asp:TextBox>
        <asp:TextBox class="form-control" ID="txtQuantityTwo" runat="server" Visible="False" placeholder="Item two qty (This field is required)"></asp:TextBox>  
        
        <asp:TextBox class="form-control" ID="txtDescriptionThree" runat="server" Visible="False" placeholder="Item three desc (This field is required)"></asp:TextBox>
        <asp:TextBox class="form-control" ID="txtQuantityThree" runat="server" Visible="False" placeholder="Item three qty (This field is required)"></asp:TextBox>
        
        <asp:TextBox class="form-control" ID="txtDescriptionFour" runat="server" Visible="False" placeholder="Item four desc (This field is required)"></asp:TextBox>
        <asp:TextBox class="form-control" ID="txtQuantityFour" runat="server" Visible="False" placeholder="Item four qty (This field is required)"></asp:TextBox>
        
        <asp:TextBox class="form-control" ID="txtDescriptionFive" runat="server" Visible="False" placeholder="Item five desc (This field is required)"></asp:TextBox>
        <asp:TextBox class="form-control" ID="txtQuantityFive" runat="server" Visible="False" placeholder="Item five qty (This field is required)"></asp:TextBox>
        
        <asp:TextBox class="form-control" ID="txtDescriptionSix" runat="server" Visible="False" placeholder="Item six desc (This field is required)"></asp:TextBox>
        <asp:TextBox class="form-control" ID="txtQuantitySix" runat="server" Visible="False" placeholder="Item six qty (This field is required)"></asp:TextBox>
        </asp:panel>
        <asp:panel id="Panel10" runat="server" groupingtext="Delivered By (This field is required)">
            <table>
                <thead>
                    <tr>
                        <th>
                            <asp:Label ID="Label1" runat="server" Text="Date (This field is required)"></asp:Label>
                        </th>
                    </tr>
                </thead>
                    <tr>
                        <td>
                            <asp:Calendar ID="calShipByDate" runat="server" onselectionchanged="calShipByDate_SelectionChanged"></asp:Calendar>
                        </td>
                    </tr>
            </table>
            <br>
            <table class="table table-hover text-center">
                <thead>
                    <tr>
                        <th>
                            <asp:Label ID="Label4" runat="server" Text="Time (This field is required)"></asp:Label> 
                        </th>
                    </tr>
                </thead>
                    <tr>
                        <td>
                            <asp:DropDownList class="form-control" ID="ddlShipByTime" runat="server">
                                <asp:ListItem>12:00 AM</asp:ListItem>
                                <asp:ListItem>1:00 AM</asp:ListItem>
                                <asp:ListItem>2:00 AM</asp:ListItem>
                                <asp:ListItem>3:00 AM</asp:ListItem>
                                <asp:ListItem>4:00 AM</asp:ListItem>
                                <asp:ListItem>5:00 AM</asp:ListItem>
                                <asp:ListItem>6:00 AM</asp:ListItem>
                                <asp:ListItem>7:00 AM</asp:ListItem>
                                <asp:ListItem>8:00 AM</asp:ListItem>
                                <asp:ListItem>9:00 AM</asp:ListItem>
                                <asp:ListItem>10:00 AM</asp:ListItem>
                                <asp:ListItem>11:00 AM</asp:ListItem>
                                <asp:ListItem>12:00 PM</asp:ListItem>
                                <asp:ListItem>1:00 PM</asp:ListItem>
                                <asp:ListItem>2:00 PM</asp:ListItem>
                                <asp:ListItem>3:00 PM</asp:ListItem>
                                <asp:ListItem>4:00 PM</asp:ListItem>
                                <asp:ListItem>5:00 PM</asp:ListItem>
                                <asp:ListItem>6:00 PM</asp:ListItem>
                                <asp:ListItem>7:00 PM</asp:ListItem>
                                <asp:ListItem>8:00 PM</asp:ListItem>
                                <asp:ListItem>9:00 PM</asp:ListItem>
                                <asp:ListItem>10:00 PM</asp:ListItem>
                                <asp:ListItem>11:00 PM</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>     
            </table>
            <table class="table table-hover text-center">
                <thead>
                    <tr>
                        <th>
                            <asp:Label ID="Label_Urgency" runat="server" Text="Urgency (This field is required)"></asp:Label>
                            <h5>If urgency is flexible, cost of shipping may be considered before ship by date.</h5>
                        </th>
                    </tr>
                </thead>
                    <tr>
                        <td>
                            <!--OnSelectedIndexChanged="ddlUrgency_SelectedIndexChanged" AutoPostBack="true">Put this back in the asp tag if using the event in code behind-->
                            <asp:DropDownList class="form-control" ID="ddlUrgency" runat="server">
                                <asp:ListItem>Lowest cost</asp:ListItem>
                                <asp:ListItem>Flexible</asp:ListItem>
                                <asp:ListItem>Non-Flexible</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
            </table>
        </asp:panel>
         <asp:panel id="Panel1" runat="server" groupingtext="Comments">     
             <asp:TextBox class="form-control" ID="txtComments" runat="server" TextMode="MultiLine"></asp:TextBox>
        </asp:panel>
         <asp:panel id="Panel7" runat="server" groupingtext="Bill to 3rd Party Account No.">
        <asp:TextBox class="form-control" ID="txtBillTo3rdParty" runat="server"></asp:TextBox>
        </asp:panel>                   
         <asp:panel id="Panel14" runat="server" groupingtext="Signature Required">        
            <asp:CheckBox ID="cbSignatureRequired" runat="server" Text="Residential Recipient's Signature Required (Additional Charge)"/>
        </asp:panel>
    <div class="wrapper text-center">
        <div class="btn-group" role="group">
            <asp:Button class="btn btn-success" ID="btnSubmit" runat="server" onclick="btnSubmit_Click" Text="Submit" /> 
            <asp:Button class="btn btn-warning" ID="btnClear" runat="server" Text="Clear" onclick="btnClear_Click" />
        </div>
    </div>
    <br />    
    <!--</div>this is for the main div-->
    <div class="clear">
    </div>
    <!--</div>this is for the page div-->
    <div class="footer">    
    </div>
    </form>
    </div>
</body>
</html>
