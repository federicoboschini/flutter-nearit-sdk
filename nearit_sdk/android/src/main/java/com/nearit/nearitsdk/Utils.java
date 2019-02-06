package com.nearit.nearitsdk;

import android.os.Parcel;
import android.os.Parcelable;
import android.support.annotation.Nullable;
import android.util.Base64;
import android.util.Log;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

import it.near.sdk.reactions.contentplugin.model.Content;
import it.near.sdk.reactions.contentplugin.model.ContentLink;
import it.near.sdk.reactions.contentplugin.model.ImageSet;
import it.near.sdk.reactions.couponplugin.model.Claim;
import it.near.sdk.reactions.couponplugin.model.Coupon;
import it.near.sdk.reactions.customjsonplugin.model.CustomJSON;
import it.near.sdk.reactions.feedbackplugin.model.Feedback;
import it.near.sdk.reactions.simplenotificationplugin.model.SimpleNotification;
import it.near.sdk.recipes.inbox.model.HistoryItem;
import it.near.sdk.trackings.TrackingInfo;

/**
 * @author Federico Boschini
 */
class Utils {

    private static final String TAG = "Utils";

    static LinkedHashMap<String, Object> bundleHistoryItem(final HistoryItem inboxItem) {
        final LinkedHashMap<String, Object> itemMap = new LinkedHashMap<>();
        itemMap.put("read", inboxItem.read);
        itemMap.put("timestamp", inboxItem.timestamp);
        itemMap.put("trackingInfo", bundleTrackingInfo(inboxItem.trackingInfo));
        itemMap.put("notificationMessage", inboxItem.reaction.notificationMessage);
        if (inboxItem.reaction instanceof SimpleNotification) {
            itemMap.put("type", SimpleNotification.class.getSimpleName());
        } else if (inboxItem.reaction instanceof Content) {
            itemMap.put("type", Content.class.getSimpleName());
            itemMap.put("content", bundleContentNotification((Content) inboxItem.reaction));
        } else if (inboxItem.reaction instanceof Feedback) {
            itemMap.put("type", Feedback.class.getSimpleName());
            itemMap.put("content", bundleFeedback((Feedback) inboxItem.reaction));
        } else if (inboxItem.reaction instanceof CustomJSON) {
            itemMap.put("type", CustomJSON.class.getSimpleName());
            itemMap.put("content", bundleCustomJson((CustomJSON) inboxItem.reaction));
        } else {
            Log.e(TAG, "NearIT :: Can\'t unbundle history item, unknown type.");
        }

        return itemMap;
    }

    static LinkedHashMap<String, Object> bundleCoupon(final Coupon coupon) {
        final LinkedHashMap<String, Object> couponMap = new LinkedHashMap<>();
        couponMap.put("title", coupon.getTitle());
        couponMap.put("description", coupon.description);
        couponMap.put("value", coupon.value);
        couponMap.put("expiresAt", coupon.expires_at);
        couponMap.put("redeemableFrom", coupon.redeemable_from);
        couponMap.put("serial", coupon.getSerial());
        couponMap.put("claimedAt", coupon.getClaimedAt());
        couponMap.put("redeemedAt", coupon.getRedeemedAt());

        // Coupon icon handling
        if (coupon.getIconSet() != null) {
            couponMap.put("image", bundleImageSet(coupon.getIconSet()));
        }

        return couponMap;
    }

    @SuppressWarnings("unused")
    static Coupon unbundleCoupon(final LinkedHashMap<String, Object> bundledCoupon) {
        Coupon coupon = new Coupon();
        coupon.name = getNullableField(bundledCoupon, "title");
        coupon.description = getNullableField(bundledCoupon, "description");
        coupon.value = getNullableField(bundledCoupon, "value");
        coupon.expires_at = getNullableField(bundledCoupon, "expiresAt");
        coupon.redeemable_from = getNullableField(bundledCoupon, "redeemableFrom");
        List<Claim> claims = new ArrayList<>();
        Claim claim = new Claim();
        claim.serial_number = getNullableField(bundledCoupon, "serial");
        claim.claimed_at = getNullableField(bundledCoupon, "claimedAt");
        claim.redeemed_at = getNullableField(bundledCoupon, "redeemedAt");
        claims.add(claim);
        coupon.claims = claims;
        if (bundledCoupon.containsKey("image")) {
            LinkedHashMap<String, Object> imageSet = (LinkedHashMap<String, Object>) bundledCoupon.get("image");
            coupon.setIconSet(unbundleImageSet(imageSet));
        }
        return coupon;
    }

    @SuppressWarnings("unused")
    static Content unbundleContentNotification(final LinkedHashMap<String, Object> bundledContent) {
        final Content content = new Content();
        content.title = getNullableField(bundledContent, "title");
        content.contentString = getNullableField(bundledContent, "text");
        final List<ImageSet> images = new ArrayList<>();
        LinkedHashMap<String, Object> imageSet = (LinkedHashMap<String, Object>) bundledContent.get("image");
        images.add(unbundleImageSet(imageSet));
        content.setImages_links(images);
        LinkedHashMap<String, Object> bundledCta = (LinkedHashMap<String, Object>) bundledContent.get("cta");
        content.setCta(unbundleContentLink(bundledCta));
        return content;
    }

    @Nullable
    static Feedback unbundleFeedback(final LinkedHashMap<String, Object> bundledFeedback) {
        String feedbackId = getNullableField(bundledFeedback, "feedbackId");
        Feedback feedback = null;
        if (feedbackId != null) {
            try {
                feedback = feedbackFromBase64(feedbackId);
            } catch (Exception e) {
                Log.e(TAG, "NearIT :: Can\'t unbundle feedback");
            }
        } else {
            Log.e(TAG, "NearIT :: Can\'t unbundle feedback");
        }
        return feedback;
    }

    static TrackingInfo unBundleTrackingInfo(HashMap<String, Object> trackingInfo) {
        final TrackingInfo tracking = new TrackingInfo();
        tracking.recipeId = (String) trackingInfo.get("recipeId");
        tracking.metadata = (HashMap<String, Object>) trackingInfo.get("metadata");

        return tracking;
    }

    private static LinkedHashMap<String, Object> bundleContentNotification(final Content contentNotification) {
        final LinkedHashMap<String, Object> content = new LinkedHashMap<>();
        content.put("title", contentNotification.title);
        content.put("content", contentNotification.contentString);
        content.put("link", contentNotification.link);
        content.put("updatedAt", contentNotification.updated_at);
        if (contentNotification.getImageLink() != null) {
            content.put("image", bundleImageSet(contentNotification.getImageLink()));
        }
        if (contentNotification.getCta() != null) {
            content.put("cta", bundleContentLink(contentNotification.getCta()));
        }

        return content;
    }

    private static LinkedHashMap<String, Object> bundleFeedback(final Feedback feedbackNotification) {
        final LinkedHashMap<String, Object> feedback = new LinkedHashMap<>();
        feedback.put("question", feedbackNotification.question);
        try {
            feedback.put("feedbackId", feedbackToB64(feedbackNotification));
        } catch (Exception e) {
            Log.e(TAG, "NearIT :: Can\'t bundle feedback.");
        }

        return feedback;
    }

    private static LinkedHashMap<String, Object> bundleCustomJson(final CustomJSON customJSONNotification) {
        final LinkedHashMap<String, Object> customJson = new LinkedHashMap<>();
        final LinkedHashMap<String, Object> content = new LinkedHashMap<>(customJSONNotification.content);
        customJson.put("content", content);

        return customJson;
    }



    private static LinkedHashMap<String, String> bundleImageSet(final ImageSet imageSet) {
        final LinkedHashMap<String, String> image = new LinkedHashMap<>();
        image.put("fullSize", imageSet.getFullSize());
        image.put("squareSize", imageSet.getSmallSize());

        return image;
    }

    private static ImageSet unbundleImageSet(LinkedHashMap<String, Object> bundledImage) {
        final ImageSet imageSet = new ImageSet();
        imageSet.setFullSize(getNullableField(bundledImage, "fullSize"));
        imageSet.setSmallSize(getNullableField(bundledImage, "squareSize"));
        return imageSet;
    }


    private static LinkedHashMap<String, Object> bundleTrackingInfo(final TrackingInfo trackingInfo) {
        final LinkedHashMap<String, Object> tracking = new LinkedHashMap<>();
        tracking.put("recipeId", trackingInfo.recipeId);
        tracking.put("metadata", trackingInfo.metadata);

        return tracking;
    }

    private static LinkedHashMap<String, String> bundleContentLink(final ContentLink contentLink) {
        final LinkedHashMap<String, String> cta = new LinkedHashMap<>();
        cta.put("label", contentLink.label);
        cta.put("url", contentLink.url);

        return cta;
    }

    private static ContentLink unbundleContentLink(LinkedHashMap<String, Object> bundledCta) {
        return new ContentLink(getNullableField(bundledCta, "label"), getNullableField(bundledCta, "url"));
    }

    private static Feedback feedbackFromBase64(final String base64) throws Exception {
        Feedback feedback;
        final Parcel parcel = Parcel.obtain();
        try {
            final ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();
            final byte[] buffer = new byte[1024];
            final GZIPInputStream zis = new GZIPInputStream(new ByteArrayInputStream(Base64.decode(base64, 0)));
            int len = 0;
            while ((len = zis.read(buffer)) != -1) {
                byteBuffer.write(buffer, 0, len);
            }
            zis.close();
            parcel.unmarshall(byteBuffer.toByteArray(), 0, byteBuffer.size());
            parcel.setDataPosition(0);

            feedback = Feedback.CREATOR.createFromParcel(parcel);
        } finally {
            parcel.recycle();
        }

        return feedback;
    }

    private static String feedbackToB64(final Feedback feedback) throws Exception {
        String base64;

        final Parcel parcel = Parcel.obtain();
        try {
            feedback.writeToParcel(parcel, Parcelable.PARCELABLE_WRITE_RETURN_VALUE);
            final ByteArrayOutputStream bos = new ByteArrayOutputStream();
            final GZIPOutputStream zos = new GZIPOutputStream(new BufferedOutputStream(bos));
            zos.write(parcel.marshall());
            zos.close();
            base64 = Base64.encodeToString(bos.toByteArray(), 0);
        } finally {
            parcel.recycle();
        }

        return base64;
    }

    private static String getNullableField(LinkedHashMap<String, Object> map, String key) {
        if (map.containsKey(key)) {
            return (String) map.get(key);
        }
        return null;
    }

}
