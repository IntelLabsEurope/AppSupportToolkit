/******************************************************************************
Copyright 2015 INTEL RESEARCH AND INNOVATION IRELAND LIMITED

Redistribution. 
--------------
Redistribution and use in binary form, without modification, are permitted 
provided that the following conditions are met:
   * Redistributions must reproduce the above copyright notice and the following
     disclaimer in the documentation and/or other materials provided with the
     distribution.
    
   * Neither the name of Intel Corporation nor the names of its suppliers may
     be used to endorse or promote products derived from this software without
     specific prior written permission.
     
   * No reverse engineering, decompilation, or disassembly of this software is 
     permitted.
     
Limited patent license.
-----------------------
Intel Corporation grants a world-wide, royalty-free, non-exclusive license
under patents it now or hereafter owns or controls to make, have made, use,
import, offer to sell and sell ("Utilize") this software, but solely to the
extent that any such patent is necessary to Utilize the software alone.
The patent license shall not apply to any combinations which include this 
software. No hardware per se is licensed hereunder.

DISCLAIMER.
-----------
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
******************************************************************************/

import com.intel.ile.*;

class CloudWaveTestHarness {

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Now some code to operate these functions defined above and 
//  see how they behave !
// Define a __main__ and lets call the native CloudWave functions
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Test Driver


  public static int adaption_count = 0;
  public static int timeout_count = 20; // twenty seconds

  public static void main(String[] args) {

    System.out.println("Hello from Java CloudWave Test Frame");
 
   // get it loaded
    CloudWave cloudwave = new CloudWave();
    // Try the ++Version++ function
    String version = cloudwave.version();  // Invoke native method
    System.out.println("version is " + version);

    //------------------------------
    // Try the ++Metric & Event++ function

    // Set some context
    int source = CloudWave.CW_SOURCE_APPLICATION;
    String name = "mynamelong";
    String metadata = "{ \"mymetadata\" : { \"taga\" : \"vala\" } }";
    String unit_of_measurement = "tps";
    int type = CloudWave.CW_METRICEVENTTYPE_GAUGE;
    long lvalue = 123L;
    double dvalue = 12.3;
    String svalue = "Hot++";
    String id = "CW_java";
    String trace="cloudwave";
    String opt_tag="";
    int retval;


    //------------------------------
    // Try the ++Metric++ function

    cloudwave.record_metric(source,
                            name,
                            metadata,
                            unit_of_measurement,
                            type,
                            lvalue);


    cloudwave.record_metric(source,
                            name,
                            metadata,
                            unit_of_measurement,
                            type,
                            dvalue);

    cloudwave.record_metric(source,
                            name,
                            metadata,
                            unit_of_measurement,
                            type,
                            svalue);

    //------------------------------
    // Try the ++Event++ function

    cloudwave.record_event(source,
                           name,
                           metadata,
                           unit_of_measurement,
                           type,
                           lvalue);


    cloudwave.record_event(source,
                           name,
                           metadata,
                           unit_of_measurement,
                           type,
                           dvalue);

    cloudwave.record_event(source,
                           name,
                           metadata,
                           unit_of_measurement,
                           type,
                           svalue);


    // -----------------------------
    // Now the Proxy ones !
    //------------------------------
    // Try the ++Metric++ function

    cloudwave.record_proxy_metric(source,
                                  name,
                                  metadata,
                                  unit_of_measurement,
                                  type,
                                  lvalue,
                                  1234,
                                  "my probe instance");

    cloudwave.record_proxy_metric(source,
                                  name,
                                  metadata,
                                  unit_of_measurement,
                                  type,
                                  dvalue,
                                  12345,
                                  "my probe instance");

    cloudwave.record_proxy_metric(source,
                                  name,
                                  metadata,
                                  unit_of_measurement,
                                  type,
                                  svalue,
                                  123456,
                                  "my probe instance");

    //------------------------------
    // Try the ++Event++ function

    cloudwave.record_proxy_event(source,
                                 name,
                                 metadata,
                                 unit_of_measurement,
                                 type,
                                 lvalue,
                                 1234567,
                                 "my probe instance");


    cloudwave.record_proxy_event(source,
                                 name,
                                 metadata,
                                 unit_of_measurement,
                                 type,
                                 dvalue,
                                 12345678,
                                 "my probe instance");

    cloudwave.record_proxy_event(source,
                                 name,
                                 metadata,
                                 unit_of_measurement,
                                 type,
                                 svalue,
                                 123456789,
                                 "my probe instance");


    // -----------------------------


    //------------------------------
    // Try the ++Post_Enactment++ function
   
    CloudWave.EnactmentPoint enactment = cloudwave.CreateEnactmentPoint();
    enactment.severity = CloudWave.CW_SEVERITY_MEDIUM;
    enactment.source = CloudWave.CW_SOURCE_APPLICATION;
    enactment.name = "test java";
    enactment.svalue = "string value java";
    enactment.lvalue = 123;
    enactment.dvalue = 12.3;
    enactment.data = "{}"; // Must be JSON !!!

    System.out.println("Enactment name is    " + enactment.name);
    System.out.println("Enactment lavalue is " + enactment.lvalue);
    System.out.println("Enactment dvalue is  " + enactment.dvalue);
    System.out.println("Enactment svalue is  " + enactment.svalue);
    System.out.println("Enactment data is    " + enactment.data);

    cloudwave.PostEnactment_long(enactment);
    cloudwave.PostEnactment_double(enactment);
    cloudwave.PostEnactment_string(enactment);



    //------------------------------
    // Try the ++Subscribe++ function
    // int SubscribeToAdaption(char *, ExecuteCallBack);

    
   
    AdaptionHandler handler = new AdaptionHandler() {
      public int adaption_received(CloudWave.AdaptionRequest request) {
	String name = "null";
        if ( null != request ) {
          name = request.name;
        }
        CloudWaveTestHarness.adaption_count++; // got one .. so count it
        System.out.println("CB event.name   = " + name );
        System.out.println("CB event.type   = " + request.type );
        System.out.println("CB event.lvalue = " + request.lvalue );
        System.out.println("CB event.dvalue = " + request.dvalue );
        System.out.println("CB event.svalue = " + request.svalue );
        System.out.println("CB event.data   = " + request.data );
        System.out.println("CB event.count  = " + CloudWaveTestHarness.adaption_count );
        CloudWaveTestHarness.timeout_count = 20;

        return (0);
      };
    };



    // try it !!!
//    handler.adaption_received(null);

    int handle = 0;
    handle = cloudwave.SubscribeToAdaption("test java test java", handler);
    System.out.println("Subscribed to 'test java test java' -> returned " + handle);


    //------------------------------
    // Now that we have subscribed
    // send an enactment to trigger it

//    cloudwave.PostEnactment_string(enactment); // test controller transponds !!


    while (CloudWaveTestHarness.timeout_count != 0)  {
      try {
        Thread.sleep(1000); //1000 milliseconds is one second. approx !
      } catch(InterruptedException ex) {
        Thread.currentThread().interrupt();
      }
      CloudWaveTestHarness.timeout_count--;
      if (CloudWaveTestHarness.timeout_count < 11) { // only mark the last 10S
        System.out.print("\r    \r" + CloudWaveTestHarness.timeout_count);
      }
    }
    if (CloudWaveTestHarness.timeout_count < 1) {
      System.out.println("\nTimeout waiting for adaption(s)");
    }
    System.out.println("\n Got adaption(s)" + CloudWaveTestHarness.adaption_count);


    //------------------------------
    // Try the ++UnSubscribe++ function
    retval = cloudwave.UnSubscribeToAdaption(handle);
    System.out.println("Unsubscribe to [" + handle + "] returned " + retval);


    // Force unsubscribe error to check ..
    //retval = cloudwave.UnSubscribeToAdaption(-1);
    //System.out.println("Unsubscribe to [-1] returned " + retval);
    //retval = cloudwave.UnSubscribeToAdaption(0);
    //System.out.println("Unsubscribe to [0] returned " + retval);



    //------------------------------
    // Try the ++Set/Get logId++ function

    cloudwave.set_logId(id);
    System.out.println("id is read back as " + cloudwave.get_logId());


    //------------------------------
    // Try the ++record_log++ function
    // void record(int level, const char* message, ...);

    try {
       cloudwave.record(CloudWave.CW_ERROR, "Am I %s ? - Hope so!", "Alive");
    } catch(Exception e)
    {
      System.out.println("Exception... on record().. ");
    }



    System.out.println("Done !!");
  }
}
