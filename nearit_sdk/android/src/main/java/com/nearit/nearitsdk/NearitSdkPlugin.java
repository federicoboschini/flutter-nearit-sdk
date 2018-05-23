package com.nearit.nearitsdk;

import android.support.annotation.NonNull;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import it.near.sdk.NearItManager;
import it.near.sdk.communication.OptOutNotifier;
import it.near.sdk.communication.TestEnrollListener;
import it.near.sdk.operation.NearItUserProfile;
import it.near.sdk.operation.values.NearMultipleChoiceDataPoint;
import it.near.sdk.reactions.Event;
import it.near.sdk.reactions.couponplugin.CouponListener;
import it.near.sdk.reactions.couponplugin.model.Coupon;
import it.near.sdk.recipes.NearITEventHandler;
import it.near.sdk.recipes.foreground.ProximityListener;
import it.near.sdk.recipes.inbox.InboxManager;
import it.near.sdk.recipes.inbox.model.InboxItem;
import it.near.sdk.trackings.TrackingInfo;

/**
 * @author Federico Boschini
 */
public class NearitSdkPlugin implements MethodCallHandler {

        private static final String IN_APP_EVENT_KEY = "inAppEvent";
        private static final String DEVICE_NAME = "deviceName";
        private static final String TRACKING_INFO = "trackingInfo";
        private static final String TRACKING_EVENT = "trackingEvent";
        private static final String PROFILE_ID = "profileId";
        private static final String USER_DATA_KEY = "userDataKey";
        private static final String USER_DATA_VALUE = "userDataValue";
        private static final String ICON_RESOURCE = "notificationIconRes";
        private static final String PROXIMITY_LISTENER = "proximityListener";
        private static final String EVENT = "event";

        private static final String START_RADAR = "startRadar";
        private static final String STOP_RADAR = "stopRadar";
        private static final String GET_COUPONS = "getCoupons";
        private static final String GET_INBOX = "getInbox";
        private static final String TRIGGER_IN_APP_EVENT = "triggerInAppEvent";
        private static final String DISABLE_DEFAULT_RANGING_NOTIF = "disableDefaultRangingNotifications";
        private static final String ENROLL_TEST_DEVICE = "enrollTestDevice";
        private static final String SEND_TRACKING = "sendTracking";
        private static final String SEND_EVENT = "sendEvent";
        private static final String OPT_OUT = "optOut";
        private static final String GET_OPT_OUT = "getOptOut";
        private static final String GET_PROFILE_ID = "getProfileId";
        private static final String SET_PROFILE_ID = "setProfileId";
        private static final String RESET_PROFILE_ID = "resetProfileId";
        private static final String SET_USER_DATA = "setUserData";
        private static final String SET_USER_DATA_MULTI = "setUserDataMulti";
        private static final String SET_BATCH_USER_DATA = "setBatchUserData";
        private static final String SET_PUSH_NOTIFICATION_ICON = "setPushNotificationIcon";
        private static final String SET_PROXIMITY_NOTIFICATION_ICON = "setProximityNotificationIcon";
        private static final String ADD_PROXIMITY_LISTENER = "addProximityListener";
        private static final String REMOVE_PROXIMITY_LISTENER = "removeProximityListener";

    private NearItManager nearItManager = NearItManager.getInstance();

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.nearit.flutter/nearit_sdk");
        channel.setMethodCallHandler(new NearitSdkPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case START_RADAR:
                startRadar();
                break;
            case STOP_RADAR:
                stopRadar();
                break;
            case GET_PROFILE_ID:
                getProfileId(result);
                break;
            case SET_PROFILE_ID:
                setProfileId(call);
                break;
            case RESET_PROFILE_ID:
                resetProfileId(result);
                break;
            case GET_COUPONS:
                getCoupons(result);
                break;
            case GET_INBOX:
                getInbox(result);
                break;
            case SET_USER_DATA:
                setUserData(call);
                break;
            case SET_USER_DATA_MULTI:
                setUserDataMulti(call);
                break;
            case SET_BATCH_USER_DATA:
                setBatchUserData(call);
                break;
            case TRIGGER_IN_APP_EVENT:
                triggerInAppEvent(call);
                break;
            case GET_OPT_OUT:
                getOptOut(result);
                break;
            case OPT_OUT:
                optOut(result);
                break;
            case SEND_EVENT:
                sendEvent(call, result);
                break;
            case SEND_TRACKING:
                sendTracking(call);
                break;
            case ENROLL_TEST_DEVICE:
                enrollTestDevice(call, result);
                break;
            case ADD_PROXIMITY_LISTENER:
                addProximityListener(call);
                break;
            case REMOVE_PROXIMITY_LISTENER:
                removeProximityListener(call);
                break;
            case DISABLE_DEFAULT_RANGING_NOTIF:
                disableDefaultRangingNotifications();
                break;
            case SET_PROXIMITY_NOTIFICATION_ICON:
                setProximityNotificationIcon(call);
                break;
            case SET_PUSH_NOTIFICATION_ICON:
                setPushNotificationIcon(call);
                break;
            default:
                result.notImplemented();
        }
    }

    private void startRadar() {
        nearItManager.startRadar();
    }

    private void stopRadar() {
        nearItManager.stopRadar();
    }

    private void getProfileId(final Result result) {
        nearItManager.getProfileId(new NearItUserProfile.ProfileFetchListener() {
            @Override
            public void onProfileId(String profileId) {
                result.success(profileId);
            }

            @Override
            public void onError(String error) {
                result.error("Error fetching profileId", error, null);
            }
        });
    }

    private void setProfileId(final MethodCall call) {
        String profileId = call.argument(PROFILE_ID);
        nearItManager.setProfileId(profileId);
    }

    private void resetProfileId(final Result result) {
        nearItManager.resetProfileId(new NearItUserProfile.ProfileFetchListener() {
            @Override
            public void onProfileId(String profileId) {
                result.success(profileId);
            }

            @Override
            public void onError(String error) {
                result.error("Error fetching profileId", error, null);
            }
        });
    }

    private void getCoupons(final Result result) {
        nearItManager.getCoupons(new CouponListener() {
            @Override
            public void onCouponsDownloaded(List<Coupon> coupons) {
                result.success(coupons);
            }

            @Override
            public void onCouponDownloadError(String error) {
                result.error("Coupons download Error", error, null);
            }
        });
    }

    private void getInbox(final Result result) {
        nearItManager.getInbox(new InboxManager.OnInboxMessages() {
            @Override
            public void onMessages(@NonNull List<InboxItem> inboxItemList) {
                result.success(inboxItemList);
            }

            @Override
            public void onError(String error) {
                result.error("Error loading Inbox", error, null);
            }
        });
    }

    private void setUserData(final MethodCall call) {
        String key = call.argument(USER_DATA_KEY);
        String value = call.argument(USER_DATA_VALUE);
        nearItManager.setUserData(key, value);
    }

    private void setUserDataMulti(final MethodCall call) {
        String key = call.argument(USER_DATA_KEY);
        NearMultipleChoiceDataPoint value = call.argument(USER_DATA_VALUE);
        nearItManager.setUserData(key, value);
    }

    private void setBatchUserData(final MethodCall call) {
        Map<String, Object> value = call.argument(USER_DATA_VALUE);
        nearItManager.setBatchUserData(value);
    }

    private void triggerInAppEvent(final MethodCall call) {
        String key = call.argument(IN_APP_EVENT_KEY);
        nearItManager.triggerInAppEvent(key);
    }

    private void getOptOut(final Result result) {
        result.success(nearItManager.getOptOut());
    }

    private void optOut(final Result result) {
        nearItManager.optOut(new OptOutNotifier() {
            @Override
            public void onSuccess() {
                result.success(null);
            }

            @Override
            public void onFailure(String error) {
                result.error("OptOut error", error, null);
            }
        });
    }

    private void sendEvent(final MethodCall call, final Result result) {
        Event event = call.argument(EVENT);
        nearItManager.sendEvent(event, new NearITEventHandler() {
            @Override
            public void onSuccess() {
                result.success(null);
            }

            @Override
            public void onFail(int statusCode, String error) {
                result.error("Error sending event", error, statusCode);
            }
        });
    }

    private void sendTracking(final MethodCall call) {
        TrackingInfo trackingInfo = call.argument(TRACKING_INFO);
        String event = call.argument(TRACKING_EVENT);
        nearItManager.sendTracking(trackingInfo, event);
    }

    private void enrollTestDevice(final MethodCall call, final Result result) {
        String deviceName = call.argument(DEVICE_NAME);
        nearItManager.enrollTestDevice(deviceName, new TestEnrollListener() {
            @Override
            public void onSuccess() {
                result.success(null);
            }

            @Override
            public void onFailure(String error) {
                result.error("Test device enrollment Error", error, null);
            }
        });
    }

    private void removeProximityListener(final MethodCall call) {
        ProximityListener proximityListener = call.argument(PROXIMITY_LISTENER);
        nearItManager.removeProximityListener(proximityListener);
    }

    private void addProximityListener(final MethodCall call) {
        ProximityListener proximityListener = call.argument(PROXIMITY_LISTENER);
        nearItManager.addProximityListener(proximityListener);
    }

    private void setProximityNotificationIcon(final MethodCall call) {
        int iconRes = call.argument(ICON_RESOURCE);
        nearItManager.setProximityNotificationIcon(iconRes);
    }

    private void setPushNotificationIcon(final MethodCall call) {
        int iconRes = call.argument(ICON_RESOURCE);
        nearItManager.setPushNotificationIcon(iconRes);
    }

    private void disableDefaultRangingNotifications() {
        nearItManager.disableDefaultRangingNotifications();
    }
}
