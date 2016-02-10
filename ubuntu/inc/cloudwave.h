/******************************************************************************
Copyright 2014 INTEL RESEARCH AND INNOVATION IRELAND LIMITED

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

#ifndef __CLOUDWAVE_C_H_INCLUDED__
#define __CLOUDWAVE_C_H_INCLUDED__


#include <stdarg.h>



#define CW_SOURCE_APPLICATION           1
#define CW_SOURCE_VM                    2
#define CW_SOURCE_LOGSERVER             3
#define CW_SOURCE_ESPER                 4

#define CW_METRIC_GAUGE                 1
#define CW_METRIC_DELTA                 2
#define CW_METRIC_CUMULATIVE            3

#define CW_METRICEVENTTYPE_GAUGE        1
#define CW_METRICEVENTTYPE_DELTA        2
#define CW_METRICEVENTTYPE_CUMULATIVE   3

#define CW_TARGET_MERLIN                1
#define CW_TARGET_MESSINA               2
#define CW_TARGET_CEILOMETER            3

#define CW_SEVERITY_LOW                 1
#define CW_SEVERITY_MEDIUM              2
#define CW_SEVERITY_HIGH                3

#define CW_DATA_TYPE_INTEGER            1
#define CW_DATA_TYPE_LONG               2
#define CW_DATA_TYPE_LONGLONG           3
#define CW_DATA_TYPE_REAL               4
#define CW_DATA_TYPE_DOUBLE             5
#define CW_DATA_TYPE_STRING             6

// Logging levels
#define CW_EMERGENCY                    0
#define CW_ALERT                        1
#define CW_CRITICAL                     2 
#define CW_ERROR                        3
#define CW_WARNING                      4
#define CW_NOTICE                       5
#define CW_INFO                         6
#define CW_DEBUG                        7

// REST service access (IBM)
#define CW_REST_HEAT			1
#define CW_REST_NOVA			2
#define CW_REST_CEILOMETER		3
#define CW_REST_NEUTRON			4

// Convenience flag for current_timestamp
#define MilliSeconds 0
#define Seconds 1



// Globals

//------------------------------------------------------------------------------

typedef struct { // User data, the rest will be filled in automatically
  int severity;
  int source;
  char * name;
  char * svalue;
  long   lvalue;
  double dvalue;
  char * data;
} CloudWaveEnactment; // object to pass to an enactment

//------------------------------------------------------------------------------

typedef struct { // Ptr to this is passed back to the Callback function
  int type;
  long lvalue;
  double dvalue;
  char * svalue;
  char * name;
  char * data;
} AdaptionRequest;

typedef int (*ExecuteCallBack)(AdaptionRequest*); // The callback function


//------------------------------------------------------------------------------
// Forward Declarations ++++Utility++++

const char * CloudWave_Version(void);
long long current_timestamp(int); // mS or (S if flag set)

//------------------------------------------------------------------------------
// Forward Declarations ++++Enactment/Adaption++++

void PostEnactment_string(CloudWaveEnactment*);
void PostEnactment_long(CloudWaveEnactment*);
void PostEnactment_double(CloudWaveEnactment*);
int SubscribeToAdaption(char *, ExecuteCallBack, void* userdata);
int UnSubscribeToAdaption(int);

//------------------------------------------------------------------------------
// Forward Declarations ++++Logging++++

int set_logId(char *);
char * get_logId(void);

//------------------------------------------------------------------------------
// Forward Declarations ++++Log Local++++

void record(int level, const char*, ...);
void vrecord(int level, const char*, va_list);

//------------------------------------------------------------------------------

/* Messina Specific metric functions */
void record_metric_longlong(int,
			const char*,
			const char*,
			const char*,
			int, // METRICEVENTTYPE
			long long);
		
void record_metric_double(int,
			const char*,
			const char*,
			const char*,
			int, // METRICEVENTTYPE
			double);
		
void record_metric_string(int,
			const char*,
			const char*,
			const char*,
			int, // METRICEVENTTYPE
			const char*);

void record_event_longlong(int,
			const char*,
			const char*,
			const char*,
			int, // METRICEVENTTYPE
			long long);
			
void record_event_double(int,
			const char*,
			const char*,
			const char*,
			int, // METRICEVENTTYPE
			double);
			
void record_event_string(int,
			const char*,
			const char*,
			const char*,
			int, // METRICEVENTTYPE
			const char*);		

//------------------------------------------------------------------------------
// Proxy !! where you want to send for somebody else !!

void record_proxy_metric_longlong(int,
			const char*,
			const char*,
			const char*,
			int,
			long long,
			long long,
			const char*);
		
void record_proxy_metric_double(int,
			const char*,
			const char*,
			const char*,
			int,
			double,
			long long,
			const char*);
		
void record_proxy_metric_string(int,
			const char*,
			const char*,
			const char*,
			int,
			const char*,
			long long,
			const char*);

void record_proxy_event_longlong(int,
			const char*,
			const char*,
			const char*,
			int,
			long long,
			long long,
			const char*);
			
void record_proxy_event_double(int,
			const char*,
			const char*,
			const char*,
			int,
			double,
			long long,
			const char*);
			
void record_proxy_event_string(int,
			const char*,
			const char*,
			const char*,
			int,
			const char*,
			long long,
			const char*);

//------------------------------------------------------------------------------
// Where you want to send a REST function command to a cloud-controller

char * CloudFunction(int,
                     char *,
                     char *);  /* string returned must be freed afterwards !*/



//------------------------------------------------------------------------------


char * Static_Decode(void); // get the task to dis-assemble itself !

//------------------------------------------------------------------------------

char * LSM_Read(char * key);
char * LSM_Store(char * key, char * value);
char * LSM_Delete_Leaf(char * key);
char * LSM_Delete_Branch(char * key);
int    LSM_change_to_bars(char * record);
int    LSM_change_to_quotes(char * record);

//------------------------------------------------------------------------------





#endif // CLOUDWAVE_C_H_
