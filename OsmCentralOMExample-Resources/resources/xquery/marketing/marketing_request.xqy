(: only require to be declared when editing with Oxygen :)
declare namespace automator = "java:oracle.communications.ordermanagement.automation.plugin.ScriptSenderContextInvocation";
(: only require to be declared when editing with Oxygen :)
declare namespace context = "java:com.mslv.oms.automation.TaskContext";
(: only require to be declared when editing with Oxygen :)
declare namespace log = "java:org.apache.commons.logging.Log";
declare namespace oms="urn:com:metasolv:oms:xmlapi:1";
declare namespace im="http://xmlns.oracle.com/InputMessage";

 
declare variable $automator external; 
declare variable $context external;
declare variable $log external;  

let $order := /oms:GetOrder.Response
let $customer := $order/oms:_root/oms:CustomerDetails
let $account := $order/oms:_root/oms:AccountDetails
let $header := $order/oms:_root/oms:OrderHeader
let $serviceLine := $order/oms:_root/oms:ControlData/oms:Functions/oms:MarketingFunction/oms:orderItem[1]
let $specs :=  $serviceLine/oms:orderItemRef/oms:lineItemPayload/im:salesOrderLine/im:itemReference/im:specificationGroup/im:specification
let $serviceId :=  $serviceLine/oms:orderItemRef/oms:serviceId/text()
let $requestedDate := $serviceLine/oms:orderItemRef/oms:requestedDeliveryDate/text()
return
(

log:info($log,fn:concat('bdm request[',/oms:GetOrder.Response/oms:OrderID,'] count[',count(/oms:GetOrder.Response/oms:_root/oms:data),']')),
<order xmlns="http://xmlns.oracle.com/communications/sce/dictionary/OsmCentralOMExample/marketing"
 xmlns:ns2="http://xmlns.oracle.com/InputMessage"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <numSalesOrder>{$header/oms:numSalesOrder/text()}</numSalesOrder>
    <numOrder>{fn:concat($order/oms:OrderID,'-',$order/oms:OrderHistID)}</numOrder>
    <typeOrder>{$header/oms:typeOrder/text()}</typeOrder>
    <category>{$account/oms:category/text()}</category>
    <dateOpen>{fn:current-dateTime()}</dateOpen>
    <dateCommitment>{$requestedDate}</dateCommitment>
    <customerAccount>
        <corporate>{$account/oms:corporate/text()}</corporate>
        <cpfClient>{$account/oms:cpfClient/text()}</cpfClient>
        <cnpjClient>{$account/oms:cnpjClient/text()}</cnpjClient>
        <customerAddress>
            <ns2:locationType>{$customer/oms:locationType/text()}</ns2:locationType>
            <ns2:nameLocation>{$customer/oms:nameLocation/text()}</ns2:nameLocation>
            <ns2:number>{$customer/oms:number/text()}</ns2:number>
            <ns2:typeCompl>{$customer/oms:typeCompl/text()}</ns2:typeCompl>
            <ns2:numCompl>{$customer/oms:numCompl/text()}</ns2:numCompl>
            <ns2:district>{$customer/oms:district/text()}</ns2:district>
            <ns2:codeLocation>{$customer/oms:codeLocation/text()}</ns2:codeLocation>
            <ns2:city>{$customer/oms:city/text()}</ns2:city>
            <ns2:state>{$customer/oms:state/text()}</ns2:state>
            <ns2:referencePoint>{$customer/oms:referencePoint/text()}</ns2:referencePoint>
            <ns2:areaCode>{$customer/oms:areaCode/text()}</ns2:areaCode>
            <ns2:typeAddress>{$customer/oms:typeAddress/text()}</ns2:typeAddress>
        </customerAddress>
    </customerAccount>
   
</order>
)