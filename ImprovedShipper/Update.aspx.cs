using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.DirectoryServices;
using System.Security.Principal;
using System.DirectoryServices.AccountManagement;
using System.Net.Mail;
using ImprovedShipper.Models;

namespace ImprovedShipper
{
    public partial class Update : System.Web.UI.Page
    {
        public string connectionSTR = "Server=AAG-Omni;Database=OAI_ShippingRequest;Integrated Security=SSPI";//MSSQL db string

        public string permissionGroup = "app-ShippingRequestManagement";//perm group name

        //SqlConnection myConnection;

        //public string path = "LDAP://omni.phish/dc=omni,dc=phish"; //<=Remove this later<=/\=>will use this for OAI=>>//"LDAP://oai.local/OU=Users,OU=OAI Company,dc=oai,dc=local";
        public string path = "LDAP://" + ConfigurationManager.AppSettings["omni.phish"] + "/dc=" + ConfigurationManager.AppSettings["sld"] + ",dc=" + ConfigurationManager.AppSettings["tld"];
        public string username = "sa-shippingrequest";
        public string password = "7ho$pf$sPlnxng";
        public string GetEmpEmailbyEmpID(string ID)
        {
            System.Diagnostics.Debug.WriteLine("***** Successfully called the GetEmpEmailbyEmpID func and param val is: " + ID + "*****");
            string EmpEmail = "";
            try
            {
                string Userfilter = "(&(objectCategory=person)(objectClass=user)(employeeID=" + ID + ")(!userAccountControl:1.2.840.113556.1.4.803:=2))";
                System.Diagnostics.Debug.WriteLine("User filter is: " + Userfilter);
                string[] UsersProperties = new string[1] { "mail" };
                //init a directory entry
                DirectoryEntry UserEntry = new DirectoryEntry(path, username, password);
                //init a directory searcher
                DirectorySearcher UserSearch = new DirectorySearcher(UserEntry, Userfilter, UsersProperties);
                SearchResultCollection UserResults = UserSearch.FindAll();
                foreach (SearchResult result in UserResults)
                {
                    EmpEmail = (string)result.Properties["mail"][0];
                    System.Diagnostics.Debug.WriteLine("***** EmpEmail Value is: " + EmpEmail + "*****");
                }
            }
            catch { }
            return EmpEmail;
        }
        public string Logged_User = HttpContext.Current.User.Identity.Name.Substring(5);//WindowsIdentity.GetCurrent().Name.Substring(5);//if dev env use substr 5, or OAI use substr 4
        public bool CheckIsInGroup(string GroupName, string UserName)
        {
            bool InGroup = false;
            PrincipalContext pc = new PrincipalContext(ContextType.Domain, ConfigurationManager.AppSettings["fqdn"], userName: "sa-shippingrequest", password: "7ho$pf$sPlnxng");
            GroupPrincipal gp = GroupPrincipal.FindByIdentity(pc, IdentityType.Name, GroupName);
            foreach (Principal p in gp.GetMembers(true))
            {
                if (p.SamAccountName == UserName)
                {
                    InGroup = true;
                    System.Diagnostics.Debug.WriteLine("User is a member of permission group and the value is " + p.SamAccountName);
                }
            }
            gp.Dispose();
            pc.Dispose();
            return InGroup;
        }
        public class LINQresult
        {
            public string Id { get; set; }
            public string Purpose { get; set; }
            public string Sender { get; set; }
            public string Address { get; set; }
            public string City { get; set; }
            public string Country { get; set; }
            public string Tracking { get; set; }
            public string Cost { get; set; }
            public string ReqDate { get; set; }
            public string Status { get; set; }
            public string Emp_Id { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var PermGroupCheck = CheckIsInGroup(permissionGroup, Logged_User);//variable to call func to check if user is in perm group

                if (PermGroupCheck != true)//if user is not in the gorup
                {
                    btnModify.Visible = false;//Update button is not visible so the can't updte the payroll status
                }
                var x = This_Request_Query();//need to add a bool to handle a null error, presently user sees a sql error
                if (x[0].Purpose == "P")//if req is for personal purp
                {
                    Label_Purpose.Text = "Personal";//the lable text will be the real word
                }
                Label_User.Text = x[0].Sender;
                Label_ReqDate.Text = x[0].ReqDate;
                Label_ToAdd.Text = x[0].Address;
                Label_ToCity.Text = x[0].City;
                Label_ToCountry.Text = x[0].Country;
                Label_Tracking.Text = x[0].Tracking;
                Label_Cost.Text = x[0].Cost.ToString();
                Label_Emp_ID.Text = x[0].Emp_Id;
            }
        }
        public List<LINQresult> This_Request_Query()
        {
            SqlConnection oneShipReq = new SqlConnection(connectionSTR);
            ShippingRequestDataContext db = new ShippingRequestDataContext(oneShipReq);
            var SummaryQuery = (from x in db.Processed_Requests
                                where x.Original_ShipID == Request.QueryString["field1"]
                                select new LINQresult
                                {
                                    Id = x.Original_ShipID,
                                    Sender = x.From_SamName,
                                    Address = x.To_AddOne,
                                    City = x.To_City,
                                    Country = x.To_Country,
                                    Tracking = x.Tracking_Num,
                                    Purpose = x.Ship_Type.ToString(),
                                    Cost = x.Total_Cost,
                                    Status = x.Payroll_Status,
                                    ReqDate = x.Ship_InitDate.ToString(),
                                    Emp_Id = x.From_EmpID
                                }).ToList();
            foreach (var record in SummaryQuery)
            {
                System.Diagnostics.Debug.WriteLine("Ship Req#: " + record.Id + " was sent by: " + record.Sender + " to " + record.Address + ", " + record.City + " in " + record.Country + " and was a " + record.Purpose + " type of shipment");
            }
            db.Dispose();
            Label_ShipID.Text = SummaryQuery[0].Id.ToString();
            return SummaryQuery;
        }
        protected void btnModify_Click(object sender, EventArgs e)//event handler to update tracking and cost info for this ship req on the page
        {
            SqlConnection updateShipReq = new SqlConnection(connectionSTR);
            ShippingRequestDataContext db = new ShippingRequestDataContext(updateShipReq);
            string thisShipReq = Request.QueryString["field1"];
            var UpdateFinder = db.Processed_Requests.Where(s => s.Original_ShipID.Equals(thisShipReq)).Select(s => s).ToList();
            foreach (var found in UpdateFinder)
            {
                found.Payroll_Status = ddlStatusUpdate.SelectedItem.Text;
                System.Diagnostics.Debug.WriteLine("UpdateFinder found " + found.Original_ShipID + " and changed the status to " + ddlStatusUpdate.SelectedItem.Text);
                db.SubmitChanges();
            }
            db.Dispose();
            string EmailDestination = GetEmpEmailbyEmpID(Label_Emp_ID.Text);
            System.Diagnostics.Debug.WriteLine("EmailDestination value is: " + EmailDestination);
            MailAddress from = new MailAddress("payroll@oai.aero");//May want to get current user email or hardcode something from payroll if only payroll employees are added to the perm group
            MailAddress to = new MailAddress(EmailDestination);//This will remain
            MailMessage message = new MailMessage(from, to);//instantiated new email msg
            message.Subject = "Payroll Deduction Acknowledgement";//will want to check with payroll on what they would like for their subject
            message.IsBodyHtml = true;//email will contain html
            message.Body = @"<html>
                            <body style='wodth:100%'>
                                <h4>Payroll Deduction </h4>
                                <p>Hello " + Label_User.Text.Substring(5) + ",<br/>" +
                                    "<p>  This email is to inform you payroll has acknowledged your personal ship request: #" + Label_ShipID.Text + ", and within 4 weeks you should expect to see a payroll deduction in the amount of $" + Label_Cost.Text + " to settle a debt to Omni Air Intl. If you have questions regarding this charge please contact payroll by responding to this email</p>" +
                               "</body>" +
                            "</html>";
            SmtpClient client = new SmtpClient();
            client.Host = "smtprelay.oai.aero";
            client.Port = 25;
            System.Diagnostics.Debug.WriteLine("Sending an email message to " + to + " by using SMTP " + client.Host);
            try
            {
                client.Send(message);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Exception caught in CreateTestMessage " + ex.ToString());
            }
        }
    }
}