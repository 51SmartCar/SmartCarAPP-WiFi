//
//  rak520.h
//  RAK52XAPI
//
//  Created by william.wei on 14/11/14.
//  Copyright (c) 2014年 rakwireless. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NabtoDevice : NSObject
@property NSMutableArray* DeviceId;
@property NSMutableArray* DeviceIp;
@end

@interface LX520 : NSObject
/**
 * Init LX520 object.
 * @param LOG  LX520 NSLOG Enable.
 * @return self.
 */
-(id)init:(BOOL)LOG;
/**
 * Init LX520 interface.
 */
+(void)LX520LibInit;
/**
 * close nabto.
 */
+(void)closenabtolib;
/**
 * Opens a Video TCP tunnel to a remote server through a Nabto enabled device.
 *
 * @param RemoteId   User Device id.
 * @param RemotePort  The TCP port to connect to on remoteHost.
 * @param LocalPort   The local TCP port to listen on.
 * @return  If the function succeeds, the return value is 0,
 *          If the function fails, the return value is one of the
 *          0 following values.
 */
+(int)VideoRemoteConnect:(NSString *)RemoteId andRemotePort:(int)RemotePort andLocalPort:(int)LocalPort;
/**
 * Check video remote connect status,Detection time interval of 1 second.
 * @return
 *            NTCS_CLOSED = -1,
 *                                The tunnel is closed.
 *            NTCS_CONNECTING = 0,
 *                                The tunnel is connecting.
 *            NTCS_READY_FOR_RECONNECT = 1,
 *                                The other end of the tunnel (the device) has disappeared. The client
 *                                must connect again.
 *            NTCS_UNKNOWN = 2,
 *                                The tunnel is connected and the tunnel is running on an unrecognized
 *                                connection type. This value indicates an internal error, since we
 *                                always know the underlying connection type if it exists.
 *            NTCS_LOCAL = 3,
 *                                The tunnel is connected and the tunnel is running on a local
 *                                connection (no Internet).
 *            NTCS_REMOTE_P2P = 4,
 *                                The tunnel is connected and the tunnel is running on a direct
 *                                connection (peer-to-peer).
 *            NTCS_REMOTE_RELAY = 5,
 *                                The tunnel is connected and the tunnel is running on a fallback
 *                                connection through the base-station.
 *            NTCS_REMOTE_RELAY_MICRO = 6,
 *                                The tunnel is connected and the tunnel is running on a connection
 *                                that runs through a relay node on the Internet. The device is
 *                                capable of using TCP/IP and the connection runs directly from the
 *                                device to the relay node to the client.
 */
+(int)CheckVideoRemoteConnectStatus;
/**
 * Check video connect error info,if VideoRemoteConnect status is closed.
 * @return error value.
 */
+(int)CheckVideoRemoteConnectErrorInfo;
/**
 * Opens a Uart TCP tunnel to a remote server through a Nabto enabled device.
 *
 * @param RemoteId   User Device id.
 * @param RemotePort  The TCP port to connect to on remoteHost.
 * @param LocalPort   The local TCP port to listen on.
 * @return  If the function succeeds, the return value is 0,
 *          If the function fails, the return value is one of the
 *          0 following values.
 */
+(int)UartOrHttpRemoteConnect:(NSString *)RemoteId andRemotePort:(int)RemotePort andLocalPort:(int)LocalPort;
/**
 * Check Uart remote connect status,Detection time interval of 1 second.
 * @return
 *         NTCS_CLOSED = -1,
 *                           The tunnel is closed.
 *         NTCS_CONNECTING = 0,
 *                            The tunnel is connecting.
 *         NTCS_READY_FOR_RECONNECT = 1,
 *                            The other end of the tunnel (the device) has disappeared. The client
 *                            must connect again.
 *         NTCS_UNKNOWN = 2,
 *                            The tunnel is connected and the tunnel is running on an unrecognized
 *                            connection type. This value indicates an internal error, since we
 *                           always know the underlying connection type if it exists.
 *         NTCS_LOCAL = 3,
 *                            The tunnel is connected and the tunnel is running on a local
 *                            connection (no Internet).
 *         NTCS_REMOTE_P2P = 4,
 *                            The tunnel is connected and the tunnel is running on a direct
 *                            connection (peer-to-peer).
 *         NTCS_REMOTE_RELAY = 5,
 *                            The tunnel is connected and the tunnel is running on a fallback
 *                            connection through the base-station.
 *         NTCS_REMOTE_RELAY_MICRO = 6,
 *                            The tunnel is connected and the tunnel is running on a connection
 *                            that runs through a relay node on the Internet. The device is
 *                            capable of using TCP/IP and the connection runs directly from the
 *                            device to the relay node to the client.
 */
+(int)CheckUartOrHttpRemoteConnectStatus;
/**
 * Check uart connect error info,if VideoRemoteConnect status is closed.
 * @return error value.
 */
+(int)CheckUartOrHttpRemoteConnectErrorInfo;
/**
 * Scan the local device information,Note that this method will block the thread.
 *
 * @param GetTimes   Scan time.
 * @return  NabtoDevice.DeviceId  Device id,
 *          NabtoDevice.DeviceIp  Device ip.
 */
-(NabtoDevice*)GetNabtoDevice:(int)GetTimes;
@end
