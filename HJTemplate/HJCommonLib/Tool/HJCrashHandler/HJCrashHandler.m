////
////  HJCrashHandler.m
////  HJTemplate
////
////  Created by zl on 2020/6/17.
////  Copyright © 2020 hhh. All rights reserved.
////
//
//#import "HJCrashHandler.h"
//#import <mach/mach.h>
//#import <mach/exception_types.h>
//#import <mach/mach_port.h>
//#import <mach/mach_init.h>
//#import <pthread.h>
//
//#define kThreadPrimary "KSCrash Exception Handler (Primary)"
//#define kThreadSecondary "KSCrash Exception Handler (Secondary)"
//
//#define EXC_UNIX_BAD_SYSCALL 0x10000  // SIGSYS
//#define EXC_UNIX_BAD_PIPE       0x10001  // SIGPIPE
//#define EXC_UNIX_ABORT           0x10002  // SIGABORT
//
//@implementation HJCrashHandler
//
///**  拿出之前的处理异常端口的handler
// */
//static struct {
//    exception_mask_t            masks[EXC_TYPES_COUNT];
//    exception_handler_t         ports[EXC_TYPES_COUNT];
//    exception_behavior_t        behaviors[EXC_TYPES_COUNT];
//    thread_state_flavor_t       flavors[EXC_TYPES_COUNT];
//    mach_msg_type_number_t  count;
//} g_previousExceptionPorts;
//
//// 自定义的异常端口 | Our exception port.
//static mach_port_t g_exceptionPort = MACH_PORT_NULL;
//
//// 主要的异常处理线程
//static pthread_t g_primaryPThread;
//static thread_t g_primaryMachThread;
//
//// 次要的异常处理线程,防止crash handler crashes
//static pthread_t g_secondaryPThread;
//static thread_t g_secondaryMachThread;
//
//static char g_primaryEventID[37];
//static char g_secondaryEventID[37];
//
//
//static bool installExceptionHandler() {
//    bool attributes_created = false;
//    pthread_attr_t attr;
//    kern_return_t kr;
//    int error;
//    const task_t thisTask = mach_task_self();
//    exception_mask_t mask = EXC_MASK_BAD_ACCESS |
//    EXC_MASK_BAD_INSTRUCTION |
//    EXC_MASK_ARITHMETIC |
//    EXC_MASK_SOFTWARE |
//    EXC_MASK_BREAKPOINT;
//    kr = task_get_exception_ports(thisTask, mask, g_previousExceptionPorts.masks, &g_previousExceptionPorts.count, g_previousExceptionPorts.ports, g_previousExceptionPorts.behaviors, g_previousExceptionPorts.flavors);
//    if(kr != KERN_SUCCESS) { goto failed; }
//    if(g_exceptionPort == MACH_PORT_NULL) {
//        kr = mach_port_allocate(thisTask, MACH_PORT_RIGHT_RECEIVE, &g_exceptionPort);
//        if(kr != KERN_SUCCESS) { goto failed; }
//        kr = mach_port_insert_right(thisTask, g_exceptionPort, g_exceptionPort, MACH_MSG_TYPE_MAKE_SEND);
//        if(kr != KERN_SUCCESS) { goto failed; }
//    }
//    kr = task_set_exception_ports(thisTask, mask, g_exceptionPort, EXCEPTION_DEFAULT, THREAD_STATE_NONE);
//    if(kr != KERN_SUCCESS) { goto failed; }
//    pthread_attr_init(&attr);
//    attributes_created = true;
//    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
//    error = pthread_create(&g_secondaryPThread, &attr, &handlerExceptions, kThreadSecondary);
//    if(error != 0) { goto failed; }
//    g_secondaryMachThread = pthread_mach_thread_np(g_secondaryPThread);
//    ksmc_add
//failed:
//    if(attributes_created) {
//        pthread_attr_destroy(&attr);
//    }
//    uninstallExceptionHandler();
//    return false;
//}
//static void uninstallExceptionHandler() {
//    
//}
//#pragma mark - Handler
//static void* handlerExceptions(void * const userData) {
//    ;//
//}
//#pragma mark -
//// 还原旧的mach exception ports
//static void restoreExceptionPorts(void) {
//    if(g_previousExceptionPorts.count == 0) { return; }
//    const task_t thisTask = mach_task_self();
//    kern_return_t kr;
//    // 重新设置旧的异常端口
//    for (mach_msg_type_number_t i = 0; i < g_previousExceptionPorts.count; i++) {
//        kr = task_set_exception_ports(thisTask, g_previousExceptionPorts.masks[i], g_previousExceptionPorts.ports[i], g_previousExceptionPorts.behaviors[i], g_previousExceptionPorts.flavors[i]);
//        if(kr != KERN_SUCCESS) {
//            mach_error_string(kr);
//        }
//    }
//    g_previousExceptionPorts.count = 0;
//}
//
//#pragma mark -  异常、信号匹配映射
//static int signalForMachException(exception_type_t exception, mach_exception_code_t code) {
//    switch(exception) {
//        case EXC_ARITHMETIC:
//            return SIGFPE;
//        case EXC_BAD_ACCESS:
//            return code == KERN_INVALID_ADDRESS ? SIGSEGV : SIGBUS;
//        case EXC_BAD_INSTRUCTION:
//            return SIGILL;
//        case EXC_BREAKPOINT:
//            return SIGTRAP;
//        case EXC_EMULATION:
//            return SIGEMT;
//        case EXC_SOFTWARE: {
//            switch (code) {
//                case EXC_UNIX_BAD_SYSCALL:
//                    return SIGSYS;
//                case EXC_UNIX_BAD_PIPE:
//                    return SIGPIPE;
//                case EXC_UNIX_ABORT:
//                    return SIGABRT;
//                case EXC_SOFT_SIGNAL:
//                    return SIGKILL;
//            }
//            break;
//        }
//    }
//    return 0;
//}
//static exception_type_t machExceptionForSignal(int signalNumber) {
//    switch(signalNumber) {
//        case SIGFPE:
//            return EXC_ARITHMETIC;
//        case SIGSEGV:
//            return EXC_BAD_ACCESS;
//        case SIGBUS:
//            return EXC_BAD_ACCESS;
//        case SIGILL:
//            return EXC_BAD_INSTRUCTION;
//        case SIGTRAP:
//            return EXC_BREAKPOINT;
//        case SIGEMT:
//            return EXC_EMULATION;
//        case SIGSYS:
//            return EXC_UNIX_BAD_SYSCALL;
//        case SIGPIPE:
//            return EXC_UNIX_BAD_PIPE;
//        case SIGABRT:
//            // The Apple reporter uses EXC_CRASH instead of EXC_UNIX_ABORT
//            return EXC_CRASH;
//        case SIGKILL:
//            return EXC_SOFT_SIGNAL;
//    }
//    return 0;
//}
//
////mach_port_t server_port;
////
////+ (void)registerCrashHandler {
////    catchMachExceptions();
////}
////void catchMachExceptions() {
////    kern_return_t rc = 0;
////    exception_mask_t excMask = EXC_MASK_BAD_ACCESS | EXC_MASK_BAD_INSTRUCTION | EXC_MASK_ARITHMETIC | EXC_MASK_SOFTWARE | EXC_MASK_BREAKPOINT;
////    rc = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &server_port);
////    if(rc != KERN_SUCCESS) {
////        fprintf(stderr, "---------->Fail to allocate exception port \n");
////        return;
////    }
////    rc = mach_port_insert_right(mach_task_self(), server_port, server_port, MACH_MSG_TYPE_MAKE_SEND);
////    if(rc != KERN_SUCCESS) {
////        fprintf(stderr, "--------->Fail to insert right");
////        return;
////    }
////    rc = thread_set_exception_ports(mach_thread_self(), excMask, server_port, EXCEPTION_DEFAULT, MACHINE_THREAD_STATE);
////    if(rc != KERN_SUCCESS) {
////        fprintf(stderr, "----------->Fail to set exception \n");
////    }
////    pthread_t thread;
////    pthread_create(&thread, NULL, exc_handler, NULL);
////}
////static void * exc_handler(void *ignored) {
////    mach_msg_return_t rc;
////    fprintf(stderr, "Exc handler listening \n");
////    typedef struct {
////        mach_msg_header_t Head;
////        mach_msg_body_t msgh_body;
////        mach_msg_port_descriptor_t thread;
////        mach_msg_port_descriptor_t task;
////        NDR_record_t NDR;
////        exception_type_t exception;
////        mach_msg_type_number_t codeCnt;
////        integer_t code[2];
////        int flavor;
////        mach_msg_type_number_t old_stateCnt;
////        natural_t old_state[144];
////    } Request;
////    Request exc;
////    struct rep_msg {
////        mach_msg_header_t Head;
////        NDR_record_t NDR;
////        kern_return_t RetCode;
////    } rep_msg;
////    for(;;) {
////        rc = mach_msg(&exc.Head, MACH_RCV_MSG|MACH_RCV_LARGE, 0, sizeof(Request), server_port, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
////        if(rc != MACH_MSG_SUCCESS) {
////            break;
////        }
////        printf("Got message %d. Exception : %d Flavor : %d. Code %d/%d. State count is %d \n", exc.Head.msgh_id, exc.exception, exc.flavor, exc.code[0], exc.code[1], exc.old_stateCnt);
////        rep_msg.Head = exc.Head;
////        rep_msg.NDR = exc.NDR;
////        rep_msg.RetCode = KERN_FAILURE;
////        kern_return_t result;
////        if(rc == MACH_MSG_SUCCESS) {
////            result = mach_msg(&rep_msg.Head, MACH_SEND_MSG, sizeof(rep_msg), 0, MACH_PORT_NULL, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
////        }
////    }
////    return NULL;
////}
//
//@end
